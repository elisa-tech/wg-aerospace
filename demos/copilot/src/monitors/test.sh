#!/usr/bin/env bash

# License: SPDX-License-Identifier: MIT

SCRIPT_DIR=$(dirname $(realpath "$0"))

COUNTER=0;
for i in $SCRIPT_DIR/tests/*; do
  ./main_syslog_test $$i > /dev/null 2>/dev/null ;
  RES=$? ;
  if [[ "$i" == *"good" && "$RES" == "0" ]] ; then
    tput setaf 2; echo -en "Test $COUNTER:  $i  [Passed]" ; tput sgr0; echo "" ;
  elif [[ "$i" == *"bad" && "$RES" == "1" ]] ; then
    tput setaf 2; echo -en "Test $COUNTER:  $i  [Passed]" ; tput sgr0; echo "" ;
  else
    tput setaf 1; echo -en "Test $COUNTER:  $i  [Failed]" ; tput sgr0; echo "" ;
  fi ;
  COUNTER=$((COUNTER + 1));
done | column -t -c0
