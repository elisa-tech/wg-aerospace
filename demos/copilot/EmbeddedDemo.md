<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Embedded

The embedded cabin lights demo runs the client, server and Copilot monitor
inside an AArch64 Linux system emulated by QEMU. Copilot is the runtime
verification framework used to generate the monitor.

See the [standalone environment](../docs/embedded-environments/Standalone.md)
for the deployment diagrams and operating system image source.
This page describes the ordinary cabin lights demo, without cFS.

## Build

Assume the repository was cloned during
[Environment Setup](../docs/EnvSetup.md) and opened in its devcontainer,
as for the [Basic Demo](BasicDemo.md).

Run the following commands inside the devcontainer. The workspace path
below is the container path, not a path on the host.

```bash
cd /workspaces/wg-aerospace/demos/copilot/src/monitors
make prep
make
make prep_cross
make main_syslog_time_cross
```

- `make prep` prepares the development environment when invoked from the
  host; inside the devcontainer it reports that no preparation is needed.
- `make` generates the Copilot monitors and builds the native applications.
- `make prep_cross` removes existing cross inputs and generated files,
  then downloads and extracts the prebuilt kernel, root filesystem and
  cross-compilation SDK, and relocates the SDK. Run it for initial setup;
  skip it when reusing an already prepared environment.
- `make main_syslog_time_cross` builds the AArch64 monitor and packages it,
  the Python applications and the tests into `rootfs.cpio.gz_new`.

Check the generated executable:

```bash
cd /workspaces/wg-aerospace/demos/copilot/src/monitors
file main_syslog_time_cross
```

On the validated x86_64 host, the output identified a 64-bit ARM AArch64
ELF executable. This executable runs in the guest.

## Launch

From the same directory inside the devcontainer:

```bash
make main_syslog_time_cross_run
```

The target launches QEMU with:

| Setting | Value |
| --- | --- |
| Machine | `virt` |
| CPU | `cortex-a57` |
| Virtual CPUs | 4 |
| Memory | 512 MB |
| Kernel | `Image` |
| Root filesystem | `rootfs.cpio.gz_new` |
| Console | `ttyAMA0`, displayed in the terminal |

Run one instance at a time. The launch target first stops existing QEMU
processes matching this demo's root filesystem.

### Log in and start the applications

At `buildroot login:`, enter `root`. The following commands run inside
**the QEMU guest**, not the development container.

Start with a fresh guest and enter the monitor directory. Prepare empty
logs and a FIFO for sending delay commands to the server:

```sh
cd /root/monitors
: > syslog_file
: > log_file
: > monitorOutput.log
mkfifo testInput
exec 3<>testInput
```

File descriptor 3 keeps the FIFO open so commands can be sent from the
same shell without a separate terminal or a background `tail` process.

Start the server, configure a 400 ms delay, then start the monitor and
client in the background. Save their process IDs for cleanup:

```sh
python3 ../python/lightServer.py < testInput > server.log 2>&1 &
server_pid=$!
echo "fixed 400" >&3
sleep 1
./main_syslog_time > monitorOutput.log 2>&1 &
monitor_pid=$!
python3 ../python/switch.py > client.log 2>&1 &
client_pid=$!
```

### Observe normal responses

```sh
tail -f syslog_file monitorOutput.log
```

The shared log shows `switch: on/off` requests followed by `lights: on/off`
responses. Compare their timestamps. With a 400 ms server delay, the
validated run showed responses approximately 400 ms after requests and
no monitor violation. Communication and scheduling add overhead to the
configured server delay.

Press `Ctrl+c` to stop viewing the logs. The background applications
continue running. Check that the monitor remains alive:

```sh
kill -0 "$monitor_pid" && echo "Monitor is still running"
```

### Inject a delayed response

Configure the server to wait 600 ms before acting on each received command:

```sh
echo "fixed 600" >&3
sleep 4
cat monitorOutput.log
```

The monitor checks a 500 ms response limit. The validated run reported:

```text
Monitor violation: light switch didn't turn off on time.
```

Depending on which command is delayed, the message can instead refer to
turning the light on. The monitor exits after detecting a violation;
this is expected in this fault-injection step. The client and server
continue running until stopped.

### Stop the applications and exit

Stop the client and server using their supported shutdown signal, wait
for them, and terminate the monitor if it has not already exited:

```sh
kill -USR1 "$client_pid" "$server_pid"
wait "$client_pid"
wait "$server_pid"
kill "$monitor_pid" 2>/dev/null
wait "$monitor_pid" 2>/dev/null
exec 3>&-
rm -f testInput
```

The monitor may already have exited with a nonzero status after detecting
the injected violation. A nonzero `wait` result in that case is expected.

Press `Ctrl+a`, release the keys, then press `x` to exit QEMU and return
to the development container. For another manual run, boot a fresh guest
and repeat the procedure so old events are not reused.

## Automated tests

Exit the manual QEMU session first. Run the following commands from the
same monitor directory inside the devcontainer. The guest application
test is the main automated check; the boot-only check is optional.

### Run guest application tests

```bash
make main_syslog_time_cross_test
```

This invokes [wrap-qemu.py](src/tests/wrap-qemu.py), which starts QEMU,
sends commands to the guest and writes the captured report to
`demos/test-results/test-results-system-cross.xml`.

Inspect the report from the current directory:

```bash
cat ../../../test-results/test-results-system-cross.xml
```

The validated run produced four tests, with zero failures and errors.
Check that tests actually ran and that the number of `testcase` elements
matches the reported test count. Do not rely only on the wrapper exit
status or the `Tests Completed Successfully.` message:
[runtests.sh](src/tests/runtests.sh) also prints that message when tests fail.

### Optional boot smoke test

```bash
make main_syslog_time_cross_run_ci
```

This invokes [test-qemu-launch.py](src/tests/test-qemu-launch.py) and checks
for `Welcome to Buildroot`. It verifies a boot milestone, rather than
application behavior.

### Run all test groups

```bash
make test
```

This combines the monitor tests, native system tests and QEMU guest system
tests. The monitor test script uses `column`; if it is missing from the
development container, install its package:

```bash
sudo apt-get update
sudo apt-get install -y bsdextrautils
```

Reports are written under `demos/test-results`:

| Report | Validated test count | Failures |
| --- | --- | --- |
| `test_results.xml` | 2 | 0 |
| `test-results-system.xml` | 4 | 0 |
| `test-results-system-cross.xml` | 4 | 0 |

These groups were validated separately using `make test_monitors`,
`make systemtest` and `make main_syslog_time_cross_test`. The combined
`make test` command is the repository's existing aggregate target.

## Observations

The switch sends on/off commands to the light server. The monitor reads
application events and checks the response time against the 500 ms limit
in [MainSyslogClock.hs](src/monitors/MainSyslogClock.hs).

The system tests exercise normal behavior and an injected 600 ms server
delay, using both ordinary communication and raw sockets. Detecting a
monitor violation is the expected result for the injected-delay cases.

The automated workflow was validated on Ubuntu 22.04.5 LTS with an x86_64
host, using source revision
`ce13ca1584889a384c8f94fb34fcba1f0a157fa7`. The container provided Copilot
4.8, GHC 9.10.3, GCC 15.3.0, QEMU 11.0.3 and Python 3.14.8.

The source copy used for validation had LF line endings. If scripts fail
with `bash\r: No such file or directory`, check for Windows CRLF line
endings and convert affected scripts to LF in the experimental copy.

## Further work

The following items preserve the remaining topics from the original
outline. They are not covered by the validated procedure above; confirm
their scope with the maintainers before expanding this walkthrough.

### Build the operating system from source

TBD: document the supported operating system build configuration and
commands, including how to produce the kernel, cpio root filesystem and
SDK consumed by this demo. The current procedure uses prebuilt outputs;
it does not validate a full operating system build. See the
[standalone environment](../docs/embedded-environments/Standalone.md)
for the image project.

### Explain guest networking

TBD: describe the client/server addresses, ports and ordinary versus raw
socket communication paths, with a deployment or sequence diagram.
Distinguish application networking inside the guest from the optional
serial socket configured by the interactive QEMU target.

### Modify the kernel configuration

TBD: provide a reproducible example of changing the kernel configuration,
rebuilding the affected image and observing the effect on the demo.
Record the configuration, build revision and expected outcome.

### Tailor the Copilot specification

TBD: demonstrate changing a monitor requirement in
[MainSyslogClock.hs](src/monitors/MainSyslogClock.hs), regenerating the
monitor, cross-compiling it and repackaging the root filesystem.
Repeat normal and fault-injection scenarios to show how the changed
requirement affects detection. The existing delay walkthrough changes
application behavior, not the monitor specification.

### Extend the demo to another use case

TBD: explain which application events, monitor rules and tests must be
adapted for another use case. Include annotated normal and fault logs
and show that the adapted system exercises the intended requirement.

### Explore diagram-based monitor generation

Open question from the original outline: can a Mermaid or state-machine
diagram be used as input to a monitor-generation workflow? Confirm the
supported tooling and input format before documenting executable steps;
this demo does not currently demonstrate generation from Mermaid.
