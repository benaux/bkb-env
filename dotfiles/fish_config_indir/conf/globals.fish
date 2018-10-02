# GLOBALS
set -gx INFOPATH "/home/bkb/.guix-profile/share/info" $INFOPATH

set -gx MANPATH "$HOME/.opam/system/man:/usr/share/man:/usr/local/share/man:/opt/X11/share/man:/usr/local/MacGPG2/share/man:$HOME/.opam/system/man"

set -g SHELL fish
set -gx GUITERM 'lxterminal'

set -g -x VISUAL vim
set -g -x EDITOR vim
set -g -x PAGER less
set -g -x DOCHOME ~/docs

