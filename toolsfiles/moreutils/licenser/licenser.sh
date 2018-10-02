#!/bin/sh

# licenser - Choose a license
#
# Copyright (c) 2018, ben@auxdir.com. All rights reserved.
# Licensed under the MIT License. See LICENSE-MIT.txt in the project root for lincense information.

USAGE="listall | [ license ] [ show | copy path]"

# with thanks to 'choosealicense.com'

what=$1
action=$2
copypath=$3

realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1 ;}

scriptdir=$(dirname $(realpath $0))

if [ -n "$what" ]; then
   case "$what" in
      listall)
         ls $scriptdir/licenses
         ;;
      -h*|--help)
         usage "$USAGE"
         ;;
      *)
         licpath=$(echo "$scriptdir/licenses/$what"*)
         if [ -d "$licpath" ] ; then
            case "$action" in
               show)
                  desc=$licpath/desc.txt
                  if [ -f "$desc" ] ; then
                     more "$desc"
                  else
                     die "Err: could not find desc file in $desc"
                  fi
                  ;;
               copy)
                  lic=$licpath/LICENSE.txt
                  target=
                  if [ -d "$copypath" ] ;then
                     target="$copypath"
                  else
                     target=.
                  fi
                  if [ -f "$lic" ] ; then
                     rm -f "$target/LICENSE.txt"
                     cp "$lic" "$target/LICENSE.txt"
                  else
                     die "Err: could not find desc file in $desc"
                  fi
                  ;;
               *)
                  die "Err: unknown action"
                  ;;
            esac
         else
            die "Err: something wrong with input '$what'"
         fi
   esac
else
   ls $scriptdir/licenses
fi





