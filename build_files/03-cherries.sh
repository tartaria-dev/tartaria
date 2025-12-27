#!/bin/sh
# install dotfiles

echo "::group::===========================> Install cherries"

set -ouex pipefail

# install cherries
git clone "https://github.com/tartaria-dev/cherries.git" /usr/share/tartaria/cherries

# setup default Niri config
install -d /etc/niri/
cp -f /usr/share/tartaria/cherries/dot_config/niri/config.kdl /etc/niri/config.kdl
file /etc/niri/config.kdl | grep -F -e "empty" -v
stat /etc/niri/config.kdl

# add Niri wants
add_wants_niri() {
    sed -i "s/\[Unit\]/\[Unit\]\nWants=$1/" "/usr/lib/systemd/user/niri.service"
}
add_wants_niri udiskie.service
add_wants_niri foot.service

echo "::endgroup::"
