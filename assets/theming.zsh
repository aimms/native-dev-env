#!/bin/zsh

# shellcheck disable=SC1090
source $HOME/.bashrc
pip install sty

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
powerlevel="powerlevel10k\\/powerlevel10k"
sed -i "s/robbyrussell/$powerlevel/g" $HOME/.bashrc

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

read -r -d '' header << 'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.bashrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

EOF

cat << EOF > $HOME/.bashrc

$header
$(<$HOME/.bashrc)

$(<$HOME/.bashrc.pre-oh-my-zsh)
EOF

cat << 'EOF' >> $HOME/.bashrc
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

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
EOF

rm -f $HOME/.bashrc.pre-oh-my-zsh

# shellcheck disable=SC1090
source $HOME/.bashrc

pushd /root/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus || exit

./mbuild
./install
popd || exit
