# shellcheck disable=SC2034
typeset -g ZPLG_MOD_DEBUG=1

module_path+=( "/usr/local/zinit/bin/zmodules/Src" )
zmodload zdharma/zplugin

zpmod source-study
