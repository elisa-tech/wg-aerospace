# License: SPDX-License-Identifier: MIT

.PHONY: default clean prep

default: main_syslog

prep:
	cabal update
	cabal v2-install --lib copilot copilot-core copilot-c99 copilot-language copilot-theorem copilot-libraries copilot-interpreter copilot-prettyprinter

elisa-v2.c elisa-v2.h elisa-v2_types.h: Main.hs Auxiliary.hs
	runhaskell Main.hs

main_syslog: main_syslog.c elisa-v2.c elisa-v2.h elisa-v2_types.h
	gcc main_syslog.c elisa-v2.c -o $@

clean:
	rm -f main_syslog elisa-v2.c elisa-v2.h elisa-v2_types.h
