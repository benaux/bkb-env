#!/bin/sh

# sync test

cwd=$(pwd)

redir=$HOME/homebase/redir
auxdir=$HOME/aux

docs=$auxdir/docs

exohome=$HOME/.exo

[ -d "$redir" ] || mkdir "$redir" 
[ -d "$auxdir" ] || mkdir "$auxdir" 
[ -d "$exohome" ] || mkdir "$exohome" 

rm -f $redir/aux
ln -s $auxdir $redir/aux

rm -f $redir/env
ln -s $cwd $redir/env

rm -f $exohome/tools
ln -s $cwd/exotools $exohome/tools

mkdir -p $docs

rm -f $redir/docs
ln -s $docs $redir/docs

rm -f $docs/cheats
ln -s $cwd/cheats $docs/cheats


#link to redir
for d in  tools vimfiles tmuxfiles cheats cheatsheet.txt dotfiles exotools; do
	[ -e "$d" ] || continue
	rm -f $redir/$d
	ln -s $cwd/$d $redir/$d

  [ -f "$d/install.sh" ] && {
    echo cd $d
    cd $d
    sh ./install.sh
    cd $cwd
  }
done


for t in tools/*; do
   [ -e "$t" ] || continue
   bt=$(basename $t)

   rm -f $redir/$bt
   ln -s $cwd/$t $redir/$bt

   rm -f $auxdir/$bt
   ln -s $cwd/$t $auxdir/$bt
done

# exotools
exohome=$HOME/.exo
mkdir -p $exohome/log
rm -f $exohome/tools
ln -s $cwd/exotools $exohome/tools


rm -f $redir/.exo
ln -s $exohome $redir/.exo
rm -f $redir/exotools
ln -s $cwd/exotools $redir/

# link from ~/ to redir/
for d in Downloads local share Dropbox ; do
   [ -d "$HOME/$d" ] || continue
   rm -f $redir/$d
   ln -s $HOME/$d $redir/$d
done

rm -f $redir/boot.sh
ln -s $cwd/boot.sh $redir/


share=$HOME/share
mkdir -p $HOME/share
rm -f $redir/share
ln -s $HOME/share $redir/share
mkdir -p $redir/aux

for d in aux-*-site; do
   [ -d "$d" ] || continue
   nm=${d#*-}
   rm -f $redir/aux/$nm
   ln -s $cwd/$d $redir/aux/$nm

   lang=${nm%-*}
   mkdir -p $share/$lang
   rm -f $share/$lang/site
   ln -s $cwd/$d $share/$lang/site
   rm -f $redir/$nm
   ln -s $cwd/$d $redir/$nm
done
