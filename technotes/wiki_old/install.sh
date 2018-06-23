#!/bin/sh


aux=$HOME/aux

[ -d $aux ] || mkdir $aux

rm -f $aux/wiki
ln -s $(pwd) $aux/wiki
