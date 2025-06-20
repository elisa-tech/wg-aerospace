# License: SPDX-License-Identifier: MIT

CONTAINER_IMG = registry.gitlab.com/elisa-tech/aero-wg-ci/copilot:latest
CONTAINER_ARGS = -e HOST_UID="$(shell id -u)" -e HOST_GID="$(shell id -g)" -v $(PWD)/../:/demo
CONTAINER_TEST_ARGS = -e HOST_UID="$(shell id -u)" -e HOST_GID="$(shell id -g)" -v $(PWD)/../../../:/demo

# Determine the docker run prefix based on no executing on a xfs filesystem (issue with ownership and encryption)
RUN_PREFIX := $(if $(shell mount | grep -q 'xfs' && echo 1),,docker run --rm $(CONTAINER_ARGS) $(CONTAINER_IMG))
RUN_PREFIX_TEST := $(if $(shell mount | grep -q 'xfs' && echo 1),,docker run --rm $(CONTAINER_TEST_ARGS) $(CONTAINER_IMG))
RUN_IT_PREFIX := $(if $(shell mount | grep -q 'xfs' && echo 1),,docker run --rm -it $(CONTAINER_ARGS) $(CONTAINER_IMG))
DEMO_CHDIR := $(if $(shell mount | grep -q 'xfs' && echo 1),,cd /demo/monitors &&)
CMD_PREFIX := $(if $(shell mount | grep -q 'xfs' && echo 1),,$(DEMO_CHDIR) export "PATH=$$PATH:/opt/ghc/8.6.5/bin/" &&)

# TODO add CICD adjustments to prefix and when detecting that we're running inside a container (for the `make dev` case)

.PHONY: default clean prep runs test test_monitors

default: main_syslog main_syslog_local main_syslog_time

# Defaulting to docker as prefered because of the setup complexities with environments.
# See CoPilot docs for manually configuring an environment which supports haskell.
prep:
	docker pull $(CONTAINER_IMG)

prep_cross: prep prep_cross_clean
	@if [ ! -f "archive.tar" ]; then \
		wget "https://gitlab.com/api/v4/projects/61362364/packages/generic/minimal-linux-debug/1.0.0/archive.tar" -O archive.tar; \
	fi
	tar xf archive.tar
	tar xf aarch64-buildroot-linux-musl_sdk-buildroot.tar.gz && rm -f aarch64-buildroot-linux-musl_sdk-buildroot.tar.gz

prep_cross_clean:
	sudo rm -rf aarch64-buildroot-linux-musl_sdk-buildroot* Image rootfs.cpio* extracted_cpio

env-debug:
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) export'
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) gcc --version'
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) runhaskell --version'

dev:
	$(RUN_IT_PREFIX)

# To debug haskell dependencies, add a -v before any *.hs
elisa-v2.c elisa-v2.h elisa-v2_types.h: Main.hs Auxiliary.hs
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) runhaskell Main.hs'

elisa-time.c elisa-time.h elisa-time_types.h: MainSyslogClock.hs Auxiliary.hs
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) runhaskell MainSyslogClock.hs'

main_syslog: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) gcc main_syslog.c elisa-v2.c -o $@'

main_syslog_local: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) gcc -DLOG_PATH=\"log_file\" -DNOTAIL main_syslog.c elisa-v2.c -o $@'

main_syslog_time: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) gcc -DLOG_PATH=\"syslog_file\" main_syslog_time.c elisa-time.c -o $@'

main_syslog_time_cross: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) cd /demo/monitors/aarch64-buildroot-linux-musl_sdk-buildroot && ./relocate-sdk.sh && cd .. && /demo/monitors/aarch64-buildroot-linux-musl_sdk-buildroot/bin/aarch64-linux-gcc -DLOG_PATH=\"syslog_file\" main_syslog_time.c elisa-time.c -o $@'
	sudo rm -rf extracted_cpio && mkdir -p extracted_cpio && sudo gunzip -c rootfs.cpio.gz > rootfs.cpio_uncompressed
	sudo cpio -i -R +0:+0 -n -F rootfs.cpio_uncompressed --make-directories --preserve-modification-time --no-absolute-filenames --directory=./extracted_cpio
	sudo cp -rf  ../python ../tests  ./extracted_cpio/root/
	sudo mkdir ./extracted_cpio/root/monitors
	sudo cp -f  main_syslog_time_cross  ./extracted_cpio/root/monitors/main_syslog_time
	sudo chmod 0755 ./extracted_cpio/root/monitors/main_syslog_time
	sh -c 'cd extracted_cpio && sudo find . | sudo cpio -H newc -o | gzip -c > ../rootfs.cpio.gz_new'

main_syslog_time_cross_run: main_syslog_time_cross
	qemu-system-aarch64 -M virt -m 512M -cpu cortex-a57 -smp 4 -nographic -kernel Image -initrd rootfs.cpio.gz_new -append "root=/dev/ram0 console=ttyAMA0"

main_syslog_test: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) gcc -DLOG_PATH=\"syslog_file\" -DCLOSE_AT_END -DNOTAIL main_syslog_time.c elisa-time.c -o $@'

clean:
	sudo rm -rf main_syslog main_syslog_local main_syslog_time main_syslog_time_cross \
	       main_syslog_test elisa-v2.c elisa-v2.h elisa-v2_types.h elisa-time.*

run: main_syslog_time
	# Start a new tmux session
	# Split the window into 3 panes
	# Run commands in each pane
	# Attach to the tmux session
	$(RUN_IT_PREFIX) sh -c "$(DEMO_CHDIR) echo \
		&& touch log_file syslog_file \
		&& export TERM=xterm-256color \
		&& tmux new-session -d -s my_session \
		&& tmux split-window -h \
		&& tmux split-window -v \
		&& tmux select-pane -L \
		&& tmux split-window -v \
		&& tmux send-keys -t my_session:0.1 \"tail -f syslog_file\" C-m \
		&& tmux send-keys -t my_session:0.2 \"python3 ../python/lightServer.py\" C-m \
		&& sleep 1 \
		&& tmux send-keys -t my_session:0.0 \"bash -i <<< './main_syslog_time; exec </dev/tty'\" C-m \
		&& tmux send-keys -t my_session:0.3 \"python3 ../python/switch.py\" \
		&& tmux attach-session -t my_session"
	# To kill session, `Ctrl-b` then type `:kill-session` <enter>

test: test_monitors systemtest

test_monitors: main_syslog_test
	./test.sh
		
systemtest: main_syslog_time
	$(RUN_PREFIX_TEST) sh -c "cd /demo/copilot/src/monitors \
		&& ../tests/runtests.sh"