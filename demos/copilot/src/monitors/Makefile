# License: SPDX-License-Identifier: MIT

CONTAINER_IMG = registry.gitlab.com/elisa-tech/aero-wg-ci/copilot:latest
CONTAINER_ARGS = -e HOST_UID="$(shell id -u)" -e HOST_GID="$(shell id -g)" -v $(PWD)/../:/demo

.PHONY: default clean prep run

default: main_syslog main_syslog_local main_syslog_time

prep:
	docker pull $(CONTAINER_IMG)

dev:
	docker run -it $(CONTAINER_ARGS) $(CONTAINER_IMG)

elisa-v2.c elisa-v2.h elisa-v2_types.h: Main.hs Auxiliary.hs
	docker run --rm $(CONTAINER_ARGS) $(CONTAINER_IMG) sh -c "cd /demo/monitors && /opt/ghc/8.6.5/bin/runhaskell Main.hs"

elisa-time.c elisa-time.h elisa-time_types.h: MainSyslogClock.hs Auxiliary.hs
	docker run --rm $(CONTAINER_ARGS) $(CONTAINER_IMG) sh -c "cd /demo/monitors && /opt/ghc/8.6.5/bin/runhaskell MainSyslogClock.hs"

main_syslog: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	docker run --rm $(CONTAINER_ARGS) $(CONTAINER_IMG) sh -c "cd /demo/monitors && gcc main_syslog.c elisa-v2.c -o $@"

main_syslog_local: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	docker run --rm $(CONTAINER_ARGS) $(CONTAINER_IMG) sh -c "cd /demo/monitors && gcc -DLOG_PATH='\"log_file\"' -DNOTAIL main_syslog.c elisa-v2.c -o $@"

main_syslog_time: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	docker run --rm $(CONTAINER_ARGS) $(CONTAINER_IMG) sh -c "cd /demo/monitors && gcc -DLOG_PATH='\"syslog_file\"' main_syslog_time.c elisa-time.c -o $@"

clean:
	rm -f main_syslog main_syslog_local main_syslog_time elisa-v2.c elisa-v2.h elisa-v2_types.h elisa-time.*

run: main_syslog_time
	# Start a new tmux session
	# Split the window into 3 panes
	# Run commands in each pane
	# Attach to the tmux session
	docker run --rm -it $(CONTAINER_ARGS) $(CONTAINER_IMG) sh -c "cd /demo/monitors \
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

