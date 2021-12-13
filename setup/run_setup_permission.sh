#!/bin/bash
#
# Perform environment permissions.

# -x: print a trace (debug)
# -u: treat unset variables
# -o pipefail: return value of a pipeline
# -o posix: match the standard
set -uo pipefail

sudo usermod -aG root "${USER}"
su - "${USER}"
id -nG

sudo usermod -aG root "$USER"
sudo newgrp root

sudo adduser "$USER" root
sudo chmod 766 /etc/opcua
