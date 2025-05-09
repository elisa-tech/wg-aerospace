# License: SPDX-License-Identifier: MIT

CONTAINER_IMG = registry.gitlab.com/elisa-tech/aero-wg-ci/copilot:latest
CONTAINER_ARGS = -e HOST_UID="$(shell id -u)" -e HOST_GID="$(shell id -g)" -v $(PWD)/../:/demo

# Determine the docker run prefix based on no executing on a xfs filesystem (issue with ownership and encryption)
RUN_PREFIX := $(if $(shell mount | grep -q 'xfs' && echo 1),,docker run --rm $(CONTAINER_ARGS) $(CONTAINER_IMG))
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

main_syslog_test: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	$(RUN_PREFIX) sh -c '$(CMD_PREFIX) gcc -DLOG_PATH=\"syslog_file\" -DCLOSE_AT_END -DNOTAIL main_syslog_time.c elisa-time.c -o $@'

clean:
	rm -f main_syslog main_syslog_local main_syslog_time main_syslog_test elisa-v2.c elisa-v2.h elisa-v2_types.h elisa-time.*

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

test: test_monitors

test_monitors: main_syslog_test
	./test.sh
