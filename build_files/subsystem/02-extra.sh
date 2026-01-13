#!/bin/sh
# extra stuff

set -ouex pipefail

# use starship bash prompt
echo -e '\neval "$(starship init bash)"' > /etc/bash.bashrc