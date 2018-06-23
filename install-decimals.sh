#!/bin/sh

decimals=$HOME/decimals
before=$decimals/before
after=$decimals/after
decimalsx=$decimals/x

redir=$HOME/homebase/redir

hname=$(hostname)

die () { echo $@; exit 1; }

homebase=$HOME/homebase
[ -d "$homebase" ] || die "Err: no homebase"

rm -rf "$decimals"
mkdir -p "$decimals"
mkdir -p $before
mkdir -p $after
mkdir -p $decimalsx

mkdir -p $redir
rm -f $redir/decimals
ln -s $decimals $redir/decimals

rm -f $redir/after
ln -s $after $redir/after

rm -f $redir/before
ln -s $before $redir/before

rm -f $redir/x
ln -s $decimalsx $redir/x

[ -d "$HOME/Documents" ] && {
   rm -f $HOME/Documents/decimals
   ln -s $decimals $HOME/Documents/decimals
}

run_before () {
   local bddd=$1
   local ddd=$2

   case $bddd in
     _meta|_archive|_todo)
       continue ;;
       *_*)
         rm -f $before/$bddd
         ln -s $ddd $before/$bddd

         for dddd in $ddd/* ; do
            [ -d "$dddd" ] || continue
            bdddd=$(basename $dddd)
            case "$bdddd" in
               *_*.*)
                 rm -f $after/$bdddd
                 ln -s $dddd $after/$bdddd
                 ;;
                *) 
                 continue ;;
             esac
          done
       ;;
   esac
}

for d in $homebase/* ; do
   [ -d "$d" ] || continue
   case "$d" in
      *dir_${USER}_$hname)
         for dd in $d/* ; do
            [ -d "$dd" ] || continue
            bdd=$(basename $dd)
            case "$bdd" in
               *${USER}*.*.*)
                  rm -f $decimals/$bdd
                  ln -s $dd $decimals/$bdd
                  for ddd in $dd/* ; do
                     [ -d "$ddd" ] || continue
                     bddd=$(basename $ddd)
                     case "$bddd" in
                        *_*x)
                          rm -f $decimalsx/$bddd
                          ln -s $ddd $decimalsx/$bddd

                          for dddd in $ddd/* ; do
                             [ -d "$dddd" ] || continue
                             bdddd=$(basename $dddd)
                             run_before $bdddd $dddd
                           done
                          ;;
                        *_*)
                          run_before $bddd $ddd
                          ;;
                        *) continue ;;
                      esac
                    done
               ;;
               *) continue ;;
            esac
         done
      ;;
      *) continue ;;
   esac
 done

