#!/bin/bash

# SPDX-License-Identifier: MIT

set -e

cat /etc/os-release

echo "ubuntu ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/90-ubuntu-nopasswd

## Setup the auto shutdown script
##   Cron test to check every 10 min (20mins to shutdown if not used)
apt-get update -y && apt install -y net-tools
cat << EOM > /sbin/shutdown-if-inactive
#!/bin/bash
#
# https://serverfault.com/a/1061792
#
# Shuts down the host on inactivity.
#
# Designed to be executed as root from a cron job.
# It will power off on the 2nd consecutive run without an active ssh session.
# That prevents an undesirable shutdown when the machine was just started, or on a brief disconnect.
#
# To enable, add this entry to /etc/crontab:
# */5 *   * * *   root    /sbin/shutdown-if-inactive
#
set -o nounset -o errexit -o pipefail

MARKER_FILE="/tmp/ssh-inactivity-flag"

STATUS=\$(netstat | grep ssh | grep ESTABLISHED &>/dev/null && echo active || echo inactive)

if [ "\$STATUS" == "inactive" ]; then
  if [ -f "\$MARKER_FILE" ]; then
    echo "Powering off due to ssh inactivity."
    poweroff  # See https://unix.stackexchange.com/a/196014/56711
  else
    # Create a marker file so that it will shut down if still inactive on the next time this script runs.
    touch "\$MARKER_FILE"
  fi
else
  # Delete marker file if it exists
  rm --force "\$MARKER_FILE"
fi
EOM
chmod 755 /sbin/shutdown-if-inactive
echo "*/10 * * * *   root    /sbin/shutdown-if-inactive" >> /etc/crontab

#####################################
# Test steps

# Stage Docker and make sure it's available
apt install -u docker.io -y
command -v /usr/bin/docker

# Should force the setup_env.sh to skip docker install and use the existing one.

# End of test steps
#####################################

# Run setup, build and test sequence
su -c "cd /home/ubuntu && git clone https://github.com/elisa-tech/wg-aerospace.git" ubuntu
su -c "cd /home/ubuntu/wg-aerospace && git checkout main" ubuntu
su -c "cd /home/ubuntu/wg-aerospace/demos/env && bash ./setup-env.sh" ubuntu
su -c "cd /home/ubuntu/wg-aerospace/demos/copilot/src/monitors && make" ubuntu
su -c "cd /home/ubuntu/wg-aerospace/demos/copilot/src/monitors && make test_monitors systemtest" ubuntu
