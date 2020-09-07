#!/bin/zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
powerlevel="powerlevel10k\\/powerlevel10k"
sed -i "s/robbyrussell/$powerlevel/g" ~/.zshrc

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

read -r -d '' header << 'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

EOF

cat << EOF > ~/.zshrc

$header
$(<~/.zshrc)

$(<~/.zshrc.pre-oh-my-zsh)
EOF

#pip install sty

cat << 'EOF' >> ~/.zshrc
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

rm -f ~/.zshrc.pre-oh-my-zsh

# shellcheck disable=SC1090
source ~/.zshrc

pushd /root/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus || exit

./mbuild
./install
popd || exit
