# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/fzf/shell/key-bindings.zsh"