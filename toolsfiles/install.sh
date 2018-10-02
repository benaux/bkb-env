#!/bin/sh

cwd=$(pwd)

toolsdir=$HOME/tools

redir=$HOME/homebase/redir

mkdir -p "$toolsdir" 
mkdir -p "$redir" 

rm -f $redir/tools
ln -s $toolsdir $redir/tools

for t in *; do
   [ -e "$t" ] || continue
   bt=$(basename $t)

   rm -f $toolsdir/$bt
   ln -s $cwd/$t $toolsdir/$bt

   rm -f $redir/$bt
   ln -s $cwd/$t $redir/$bt
done

