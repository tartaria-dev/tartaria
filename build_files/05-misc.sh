#!/bin/bash
# miscellaneous stuff

echo "::group::Miscellaneous tasks"

set -euo pipefail
set +x

# manually add greetd user due to rebase issues
useradd -M -G video,input -s /usr/bin/nologin greeter || true

# enable ntsync
echo -e 'ntsync' > /etc/modules-load.d/ntsync.conf

# enable bbr3
echo -e 'net.core.default_qdisc=fq 
net.ipv4.tcp_congestion_control=bbr' > /etc/sysctl.d/99-bbr3.conf

echo "::endgroup::"