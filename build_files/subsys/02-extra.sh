#!/bin/sh
# extra important stuff

echo "::group::===========================> Perform system configuration"

set -ouex pipefail

# setup fish prompt
mkdir -p /etc/fish
echo -e '\nif status is-interactive\n    starship init fish | source\n    atuin init fish | source\nend' >> /etc/fish/config.fish

echo "::endgroup::"
