#!/bin/sh


cwd=$(pwd)

redir=$HOME/homebase/redir

mkdir -p $redir


rm -rf $HOME/.vim
rm -f $redir/.vim
ln -s $cwd/vim $HOME/.vim
ln -s $cwd/vim $redir/.vim

rm -rf $HOME/.vimrc.d
rm -f $redir/.vimrc.d
ln -s $cwd/vimrc.d $HOME/.vimrc.d
ln -s $cwd/vimrc.d $redir/.vimrc.d

rm -f $HOME/.vimrc
rm -f $redir/.vimrc
ln -s $cwd/vimrc $HOME/.vimrc
ln -s $cwd/vimrc $redir/.vimrc


