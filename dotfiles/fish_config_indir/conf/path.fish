# setting PATH
# ===========
#
# stuff in ~
set DOTLOCAL_BIN $HOME/.local/bin

set -gx CARP_DIR $HOME/local/carp/Carp
#
#
#
# tools
# -----


set TOOLSDIR $HOME/tools

[ -f $TOOLSDIR/aliases.fish ] ; and source $TOOLSDIR/aliases.fish
[ -f $TOOLSDIR/functions.fish ] ; and source $TOOLSDIR/functions.fish

set -l toolbins $TOOLSDIR/utils $TOOLSDIR/moreutils/bin $TOOLSDIR/cmds $TOOLSDIR/symlinks $TOOLSDIR/sw/bin $TOOLSDIR/privutils perl-site/bin

for bin in $toolbins $DOTLOCAL_BIN
   test -d $bin ; and set -gx PATH $bin $PATH
end

# langs 
# -----
set -gx GOPATH $HOME/.gopath

set -x NEWLISPDIR /usr/local/share/newlisp-10.7.1/

set guilelibs /usr/local/Cellar/guile/2.2.2/share/guile/2.2/site
test -d $guilelibs ; and set -gx GUILE_LOAD_PATH $guilelibs

#set -l monobin /Library/Frameworks/Mono.framework/Versions/Current/bin/
set -l LLVM_HOME /usr/local/Cellar/llvm/6.0.0/
set -l GO_HOME $HOME/go
set -l CARGO_HOME $HOME/.cargo
set -l RACKET_HOME $HOME/.racket/6.9
set -l NODE_HOME $HOME/local/node/node
set -l NIM_HOME $HOME/local/nim/git/Nim
set -l NIMBLE_HOME HOME/.nimble
set -l CABAL_HOME $HOME/.cabal
set -l GAMBIT_HOME /usr/local/Gambit
set -l BUILDS_HOME $HOME/builds
set -l NPM_HOME $HOME/.npm-global
set -l GUIX_HOME $HOME/.guix-profile
set -l BIGLOO_HOME $HOME/local/bigloo/bigloo

set -l langhomes $GO_HOME $CARGO_HOME $RACKET_HOME $NODE_HOME $NIM_HOME $NIMBLE_HOME $CABAL_HOME $GAMBIT_HOME $BUILDS_HOME $NPM_HOME $GUIX_HOME $LLVM_HOME $BIGLOO_HOME

for lang in $langhomes
  set bin $lang/bin
   test -d $bin ; and set -gx PATH $bin $PATH
end

