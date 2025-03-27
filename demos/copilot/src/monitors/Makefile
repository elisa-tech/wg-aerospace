# License: SPDX-License-Identifier: MIT

.PHONY: default clean prep run

default: main_syslog main_syslog_local main_syslog_time

prep:
	cabal update
	cabal v2-install --lib copilot copilot-core copilot-c99 copilot-language copilot-theorem copilot-libraries copilot-interpreter copilot-prettyprinter

elisa-v2.c elisa-v2.h elisa-v2_types.h: Main.hs Auxiliary.hs
	runhaskell Main.hs

elisa-time.c elisa-time.h elisa-time_types.h: MainSyslogClock.hs Auxiliary.hs
	runhaskell MainSyslogClock.hs

main_syslog: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	gcc main_syslog.c elisa-v2.c -o $@

main_syslog_local: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	gcc -DLOG_PATH='"log_file"' -DNOTAIL main_syslog.c elisa-v2.c -o $@

main_syslog_time: main_syslog_time.c elisa-time.c elisa-time.h elisa-time_types.h
	gcc -DLOG_PATH='"syslog_file"' -DNOTAIL main_syslog_time.c elisa-time.c -o $@

clean:
	rm -f main_syslog main_syslog_local elisa-v2.c elisa-v2.h elisa-v2_types.h elisa-time.*

run: main_syslog_local
	# Start a new tmux session
	tmux new-session -d -s my_session

	# Split the window into 3 panes
	tmux split-window -h
	tmux split-window -v

	# Run commands in each pane
	tmux send-keys -t my_session:0.1 "python3 ../python/lightServer.py" C-m
	sleep 1
	tmux send-keys -t my_session:0.0 "bash -i <<< './main_syslog_local ; exec </dev/tty'" C-m
	tmux send-keys -t my_session:0.2 "python3 ../python/switch.py"

	# Attach to the tmux session
	tmux attach-session -t my_session
