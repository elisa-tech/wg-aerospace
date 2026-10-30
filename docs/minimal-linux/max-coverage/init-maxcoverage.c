/* SPDX-License-Identifier: CC-BY-SA-4.0 */
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <sys/mount.h>
#include <sys/time.h>
#include <sys/wait.h>

static int emit_checkpoint(const char *stage_name)
{
    char cmd[512];
    int length = snprintf(cmd, sizeof(cmd),
             "mkdir -p /tmp/dump && "
             "find /sys/kernel/debug/gcov -type d -exec mkdir -p /tmp/dump/{} \\; && "
             "find /sys/kernel/debug/gcov -name '*.gcda' -exec sh -c 'cat < \"$0\" > \"/tmp/dump/$0\"' {} \\; && "
             "tar -czf /tmp/gcda.tar.gz -C /tmp/dump sys && "
             "echo '===GCOV_%s_START===' && "
             "base64 /tmp/gcda.tar.gz && "
             "echo '===GCOV_%s_END===' && "
             "rm -rf /tmp/dump /tmp/gcda.tar.gz",
             stage_name, stage_name);
    if (length < 0 || (size_t)length >= sizeof(cmd))
        return 1;
    if (system(cmd) != 0) {
        fprintf(stderr, "CHECKPOINT FAILED: %s\n", stage_name);
        return 1;
    }
    return 0;
}

static int run_cmd(const char *label, char *const argv[], int seconds)
{
    if (access(argv[0], X_OK) != 0) {
        fprintf(stderr, "FAILED: %s executable missing\n", label);
        return 1;
    }
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return 1;
    }
    if (pid == 0) {
        if (setpgid(0, 0) != 0)
            _exit(127);
        execv(argv[0], argv);
        perror(argv[0]);
        _exit(127);
    }
    if (setpgid(pid, pid) != 0 && errno != EACCES && errno != ESRCH)
        perror("setpgid");
    struct timespec start, now;
    if (clock_gettime(CLOCK_MONOTONIC, &start) != 0)
        return 1;
    for (;;) {
        int status;
        pid_t done = waitpid(pid, &status, WNOHANG);
        if (done == pid) {
            int ok = WIFEXITED(status) && WEXITSTATUS(status) == 0;
            fprintf(stderr, "CHILD %s: status=%d %s\n", label, status, ok ? "OK" : "FAILED");
            return !ok;
        }
        if (done < 0 && errno != EINTR) {
            perror("waitpid");
            return 1;
        }
        if (clock_gettime(CLOCK_MONOTONIC, &now) != 0)
            return 1;
        if (now.tv_sec - start.tv_sec >= seconds) {
            fprintf(stderr, "WATCHDOG: %s exceeded %d seconds\n", label, seconds);
            kill(-pid, SIGKILL);
            kill(pid, SIGKILL);
            return 1;
        }
        struct timespec delay = { .tv_nsec = 100000000 };
        nanosleep(&delay, NULL);
    }
}

int main(void)
{
    int failures = 0;
    setvbuf(stdout, NULL, _IONBF, 0);
    if (mount("proc", "/proc", "proc", 0, NULL) != 0)
        perror("mount /proc"), failures++;
    if (mount("sysfs", "/sys", "sysfs", 0, NULL) != 0)
        perror("mount /sys"), failures++;
    if (mount("devtmpfs", "/dev", "devtmpfs", 0, NULL) != 0)
        perror("mount /dev"), failures++;
    if (mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL) != 0)
        perror("mount /sys/kernel/debug"), failures++;

    /* Stage 0: Boot Self-Tests */
    failures += emit_checkpoint("STAGE0_BOOT");

    /* Stage 1: /proc and /sys Attribute Traversal */
    puts("=== Stage 1: Traversing /proc and /sys attributes ===");
    char *traverse[] = {
        "/bin/sh", "-c",
        "find /proc /sys -type f 2>/dev/null | while read -r f; do "
        "case \"$f\" in "
        "*/trace_pipe*|*/kcore|*/mem|*/kmsg|*/sysrq-trigger|*/null|*/zero|"
        "/proc/[0-9]*|*/clear_refs|*/kunit/*/results) ;; "
        "*) timeout -s KILL 1 dd if=\"$f\" of=/dev/null bs=4k count=1 "
        "2>/dev/null ;; esac; done; exit 0",
        NULL
    };
    failures += run_cmd("proc/sys traversal", traverse, 900);
    failures += emit_checkpoint("STAGE1_PROCSYS");

    /* Stage 2: stress-ng, sequential class sweep */
    puts("=== Stage 2: Executing stress-ng sequential class sweep ===");
    struct itimerval zero = {0};
    int timers_ok = setitimer(ITIMER_REAL, &zero, NULL) == 0;
    if (!timers_ok)
        perror("POSIX_TIMERS required"), failures++;
    const char *classes[] = {
        "os", "scheduler", "memory", "filesystem", "interrupt"
    };
    size_t count = sizeof(classes) / sizeof(classes[0]);
    for (size_t i = 0; timers_ok && i < count; i++) {
        char *sng_argv[] = {
            "/usr/bin/stress-ng",
            "--seq", "0",
            "--class", (char *)classes[i],
            "--timeout", "1s",
            "--metrics",
            NULL
        };
        failures += run_cmd(classes[i], sng_argv, 600);
    }
    failures += emit_checkpoint("STAGE2_STRESSNG");

    /* Stage 3: Syzkaller */
    puts("=== Stage 3: Executing Syzkaller standalone sequence reproducer ===");
    char *syz_argv[] = { "/opt/syzkaller/syz-repro", NULL };
    failures += run_cmd("Syzkaller", syz_argv, 30);
    failures += emit_checkpoint("STAGE3_SYZKALLER");

    puts(failures ? "=== HARNESS INCOMPLETE ===" : "=== All test stages complete ===");
    for (;;)
        pause();
    return 0;
}
