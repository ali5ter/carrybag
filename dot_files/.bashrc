# @file .bashrc
# ★  Carrybag bash configuration
# @author Alister Lewis-Bowen <alister@different.com>

#
# Options
#

shopt -s cdspell    # Correct minor spelling errors in a cd command.
shopt -s histappend # Append to history rather than overwrite
shopt -s dotglob    # Show dot files in path expansion
#shopt -s nullglob   # Don't use * for empty dirs when using 'for i in *'

#
# Source specific configurations
#

for file in ~/.{exports,aliases,functions,completion}; do source "$file"; done
unset file

#
# OS specific configurations
#

case "$(uname)" in
    Linux)  source ~/.linux;;
    Darwin) source ~/.osx;;
esac

#
# Additional configurations/overrides
#

[ -r ~/.bashrc_local ] && source ~/.bashrc_local
