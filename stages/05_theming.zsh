#!/usr/bin/env zsh

set -e

# shellcheck disable=SC1090
source $HOME/.bashrc

a dev
pip install sty

curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

cat << 'EOF' >> $HOME/.zshrc
source <(antibody init)
antibody bundle < $HOME/.zsh_plugins.antibody

EOF

cat $HOME/.bashrc >> $HOME/.zshrc

cp /host/assets/.zsh_plugins.antibody $HOME/
cp /host/assets/.logo.py $HOME/
cp /host/assets/.p10k.zsh $HOME/
cp /host/assets/MesloLGS* /usr/share/fonts/truetype/

chown root:root $HOME/.zsh_plugins.antibody
chown root:root $HOME/.logo.py
chown root:root $HOME/.p10k.zsh
chown -R root:root /usr/share/fonts

fc-cache -vf