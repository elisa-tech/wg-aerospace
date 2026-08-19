# SPDX-License-Identifier: MIT

# Figure out the host OS so we grab the right SDK (e.g., host tools arch matches)
ARCH := $(shell uname -m)
$(info Detected architecture: $(ARCH))
MIN_OS_URL = https://gitlab.com/api/v4/projects/71533173/packages/generic/min-kernel-debug/1.0.0
ifeq ($(ARCH), x86_64)
    MIN_ARCHIVE = archive.tar
    CROSS_TOOLCHAIN=aarch64-buildroot-linux-musl_sdk-buildroot
    CROSS_PREFIX=aarch64-linux
else ifeq ($(ARCH), aarch64)
    MIN_ARCHIVE = host-arm64/archive.tar
    CROSS_TOOLCHAIN=aarch64-buildroot-linux-gnu_sdk-buildroot
    CROSS_PREFIX=aarch64-none-linux-gnu
endif

REPO_ROOT := $(abspath ../../../..)
DEVCONTAINER_CLI ?= devcontainer
IN_DEVCONTAINER := $(shell if [ -n "$$DEVCONTAINER" ] || [ -n "$$REMOTE_CONTAINERS" ] || [ -f /.dockerenv ]; then echo 1; else echo 0; fi)
RUN_CWD := $(if $(filter 1,$(IN_DEVCONTAINER)),.,demos/copilot/src/monitors)
COMMA := ,
QEMU_SERIAL_PORT ?= 45450

ifeq ($(IN_DEVCONTAINER),1)
EXEC := bash -lc
else
EXEC := $(DEVCONTAINER_CLI) exec --workspace-folder "$(REPO_ROOT)" bash -lc
endif

define exec_in_env
$(EXEC) 'cd $(RUN_CWD) && $(1)'
endef

.PHONY: default clean prep run test test_monitors main_syslog_time_cross_stop

default: main_syslog main_syslog_local main_syslog_time

prep:
	@if [ "$(IN_DEVCONTAINER)" = "1" ]; then \
		echo "Already inside the devcontainer; nothing to prepare."; \
	else \
		if ! command -v $(DEVCONTAINER_CLI) >/dev/null 2>&1; then \
			echo "devcontainer CLI is required for host-side use. Open the repo in VS Code Dev Containers or install the CLI." >&2; \
			exit 1; \
		fi; \
		$(DEVCONTAINER_CLI) up --workspace-folder "$(REPO_ROOT)"; \
	fi

# The embedded builds are documented under <toplevel>/demos/docs/embedded-environments/Readme.md
prep_cross: prep prep_cross_clean
	$(call exec_in_env,if [ ! -e archive.tar ]; then wget "$(MIN_OS_URL)/$(MIN_ARCHIVE)" -O archive.tar; fi && tar xf archive.tar && tar xf $(CROSS_TOOLCHAIN).tar.gz && rm -f $(CROSS_TOOLCHAIN).tar.gz)
	$(call exec_in_env,cd $(CROSS_TOOLCHAIN) && ./relocate-sdk.sh)

prep_cross_clean:
	$(call exec_in_env,sudo rm -rf $(CROSS_TOOLCHAIN)* Image rootfs.cpio* extracted_cpio archive.tar)

env-debug:
	$(call exec_in_env,export)
	$(call exec_in_env,gcc --version)
	$(call exec_in_env,runhaskell --version)

dev:
	$(call exec_in_env,cat /.VERSION && exec bash -l)

# To debug haskell dependencies, add a -v before any *.hs
elisa-v2.c elisa-v2.h elisa-v2_types.h: Main.hs Auxiliary.hs
	$(call exec_in_env,runhaskell Main.hs)

elisa-time.c elisa-time.h elisa-time_types.h: MainSyslogClock.hs Auxiliary.hs
	$(call exec_in_env,runhaskell MainSyslogClock.hs)

main_syslog: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	$(call exec_in_env,gcc main_syslog.c elisa-v2.c -o $@)

main_syslog_local: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	$(call exec_in_env,gcc -DLOG_PATH=\"log_file\" -DNOTAIL main_syslog.c elisa-v2.c -o $@)

main_syslog_time: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	$(call exec_in_env,gcc -DLOG_PATH=\"syslog_file\" main_syslog_time.c elisa-time.c -o $@)

main_syslog_time_cross: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	$(call exec_in_env,$(CROSS_TOOLCHAIN)/bin/$(CROSS_PREFIX)-gcc -DLOG_PATH=\"syslog_file\" main_syslog_time.c elisa-time.c -o $@)
	$(call exec_in_env,sudo rm -rf extracted_cpio && mkdir -p extracted_cpio && gunzip -c rootfs.cpio.gz > rootfs.cpio_uncompressed && cpio -i -R +0:+0 -n -F rootfs.cpio_uncompressed --make-directories --preserve-modification-time --no-absolute-filenames --directory=./extracted_cpio || true)
	$(call exec_in_env,cp -rf ../python ../tests ./extracted_cpio/root/)
	$(call exec_in_env,mkdir -p ./extracted_cpio/root/monitors && cp -f main_syslog_time_cross ./extracted_cpio/root/monitors/main_syslog_time && chmod 0755 ./extracted_cpio/root/monitors/main_syslog_time)
	# Could add other content to the `./extracted_cpio` at this point before making the new image in the next line
	$(call exec_in_env,cd extracted_cpio && sudo chown root:root . -R && sudo find . | sudo cpio -H newc -o | gzip -c > ../rootfs.cpio.gz_new)

# To use the serial port this emulation sets up
# 1) Execute the below make target to start the container
# 2) In a new shell, run the following to attach to that container
#          docker exec -it   $(docker ps | grep copilot | grep -o '^[^ ]*') /bin/bash
# 3) Run the following once attached to listen on the emulation's virtual serial port
#          sudo apt update && sudo apt install -y socat netcat && nc localhost 45450
# 4) In the emulation, login and run the following to send example message to Netcat that's listening
#          echo "Hi" > /dev/ttyS0
main_syslog_time_cross_run: main_syslog_time_cross_stop main_syslog_time_cross
	$(call exec_in_env,qemu-system-aarch64 -M virt -m 512M -cpu cortex-a57 -smp 4 -nographic -kernel Image -initrd rootfs.cpio.gz_new -chardev socket$(COMMA)id=ttyS0$(COMMA)host=localhost$(COMMA)port=$(QEMU_SERIAL_PORT)$(COMMA)server=on$(COMMA)wait=off -device pci-serial$(COMMA)chardev=ttyS0 -append "root=/dev/ram0 console=ttyAMA0")

main_syslog_time_cross_stop:
	-$(call exec_in_env,pkill -f "qemu-system-aarch64.*rootfs.cpio.gz_new" || true)

main_syslog_time_cross_run_ci: main_syslog_time_cross_stop main_syslog_time_cross
	$(call exec_in_env,python3 ../tests/test-qemu-launch.py)

main_syslog_test: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	$(call exec_in_env,gcc -DLOG_PATH=\"syslog_file\" -DCLOSE_AT_END -DNOTAIL main_syslog_time.c elisa-time.c -o $@)

clean_cross: prep_cross_clean clean prep_cross  main_syslog_time_cross main_syslog_time_cross_run

clean:
	rm -rf main_syslog main_syslog_local main_syslog_time main_syslog_time_cross \
	       main_syslog_test elisa-v2.c elisa-v2.h elisa-v2_types.h elisa-time.*

run: main_syslog_time
	# Start a new tmux session
	# Split the window into 4 panes
	# Run commands in each pane
	# Attach to the tmux session
	$(call exec_in_env,touch log_file syslog_file && export TERM=xterm-256color && tmux kill-session -t my_session >/dev/null 2>&1 || true && tmux new-session -d -s my_session && tmux split-window -h && tmux split-window -v && tmux select-pane -L && tmux split-window -v && tmux send-keys -t my_session:0.1 "tail -f syslog_file" C-m && tmux send-keys -t my_session:0.2 "python3 ../python/lightServer.py" C-m && sleep 1 && tmux send-keys -t my_session:0.0 "printf \"%s\\n\" \"./main_syslog_time; exec </dev/tty\" | bash -i" C-m && tmux send-keys -t my_session:0.3 "python3 ../python/switch.py" && tmux attach-session -t my_session)
	# To kill session, `Ctrl-b` then type `:kill-session` <enter>

test: test_monitors systemtest main_syslog_time_cross_test

test_monitors: main_syslog_test
	$(call exec_in_env,./test.sh)

systemtest: main_syslog_time
	$(call exec_in_env,sudo sh -c "cd . && ../tests/runtests.sh")

main_syslog_time_cross_test: main_syslog_time_cross_stop main_syslog_time_cross
	$(call exec_in_env,python3 ../tests/wrap-qemu.py)
