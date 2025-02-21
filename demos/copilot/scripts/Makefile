# License: SPDX-License-Identifier: MIT

.PHONY: default clean

default: main_syslog

elisa-v2.c elisa-v2.h elisa-v2_types.h: Main.hs Auxiliary.hs
	cabal v1-sandbox init
	cabal v1-install copilot-4.2
	cabal v1-exec -- runhaskell Main.hs

main_syslog: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	gcc main_syslog.c elisa-v2.c -o $@

clean:
	rm -f main_syslog elisa-v2.c elisa-v2.h elisa-v2_types.h
