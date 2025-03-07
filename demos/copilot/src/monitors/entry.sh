#!/usr/bin/env bash
set -e

NON_ROOT_USER="user"
if [[ ! -z "$HOST_UID" ]]; then
    USER_UID=$(id -u user)
    if [[ "$USER_UID" -eq "$HOST_UID" ]]; then
        echo "NOT overriding UID/GID, UID of user 'user' matches HOST_UID."
    else
        if [[ -z "$HOST_GID" ]]; then
            echo "ERROR: please set HOST_GID" >&2
            exit 1
        fi

        NON_ROOT_USER="mappedUser"
        sudo groupadd -g $HOST_GID $NON_ROOT_USER
        sudo useradd -m -u $HOST_UID -g $HOST_GID -s /bin/bash $NON_ROOT_USER
        sudo cp /home/user/.bashrc /home/$NON_ROOT_USER/ -a
        sudo chown $NON_ROOT_USER:$NON_ROOT_USER /home/$NON_ROOT_USER/.bashrc
        echo "UID/GID mapped to host user."
    fi
else
    echo 'NOT overriding UID/GID, if desired, set up Docker with'
    echo '  -e HOST_UID="$(id -u)" -e HOST_GID="$(id -g)" '
fi

export LC_ALL="en_US.UTF-8"

# APPEND HERE

# Drop privileges and execute next container command, or 'bash' if not specified.
if [[ $# -gt 0 ]]; then
    exec sudo -E -H -u $NON_ROOT_USER -- "$@"
else
    exec sudo -E -H -u $NON_ROOT_USER -- bash
fi
