# Skip the not really helping Ubuntu global compinit
# shellcheck disable=SC2034
skip_global_compinit=1

# shellcheck disable=SC2034
typeset -g ZPLG_MOD_DEBUG=1

# shellcheck disable=SC2206
module_path+=( ${ZINIT[BIN_DIR]}/zmodules/Src )
zmodload zdharma/zplugin

zpmod source-study

# initialize zinit
source ${ZINIT[HOME_DIR}/zinit.zsh
