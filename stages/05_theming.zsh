#!/bin/zsh


cp $HOME/.bashrc $HOME/.zshrc
chown root:root $HOME/.logo.py

# shellcheck disable=SC1090
source $HOME/.zshrc
a dev && pip install sty

sh -c "ZSH=$HOME/.oh-my-zsh $(wget -O - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
powerlevel="powerlevel10k\\/powerlevel10k"
sed -i "s/robbyrussell/$powerlevel/g" $HOME/.zshrc

chown -R root:root $HOME/.oh-my-zsh

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
chown -R root:root $HOME/.oh-my-zsh/custom

read -r -d '' header << 'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.bashrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

EOF

cat << EOF > $HOME/.zshrc

$header
$(<$HOME/.zshrc)

EOF

cat << 'EOF' >> $HOME/.zshrc
# zsh plugins
plugins=(
  git
  cargo
  rust
  rustup
  encode64
  gitignore
  kubectl
  pip
  pyenv
  terraform
  tmux
)

# To customize prompt, run 'p10k configure' or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
EOF

cp /host/assets/logo.py $HOME/.logo.py
chown root:root $HOME/.logo.py
cp /host/assets/MesloLGS* /usr/share/fonts/truetype/
chmod 666 /usr/share/fonts
fc-cache -vf
cp /host/assets/.p10k.zsh $HOME/
chown root:root $HOME/.logo.py

# shellcheck disable=SC1090
source $HOME/.zshrc

pushd /root/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus || exit

./mbuild
./install
popd || exit
