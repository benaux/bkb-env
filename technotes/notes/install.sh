#!/bin/sh

cwd=$(pwd)
notes=$HOME/notes

rm -f $notes
ln -s $cwd $notes




aux=$HOME/aux

[ -d "$aux" ] || mkdir $aux

rm -f $aux/notes
ln -s $cwd $aux/notes



