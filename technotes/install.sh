#!/bin/sh


cwd=$(pwd)
aux=$HOME/aux
docs=$HOME/docs


# ~/notes
rm -f $HOME/notes
ln -s $cwd $HOME/notes

# ~/docs
mkdir -p $docs
rm -f $docs/notes
ln -s $cwd $docs/noted

# ~/aux
mkdir -p $aux
rm -f $aux/notes
ln -s $cwd $aux/notes
