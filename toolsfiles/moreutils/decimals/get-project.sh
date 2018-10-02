#!/bin/sh

# in project

inp="$1"


cwd=
if [ -n "$inp" ] ; then
   cwd="$inp"
else
   cwd=$(pwd)
fi 

dircwd=$(dirname $cwd)

basedir=$(basename $cwd)

p_file=$(echo $dircwd/${basedir}_*.*)

if [ -f "$p_file" ] ; then

   # p_dir=$(dirname $p_file)

   p_name=$(basename $p_file)

   # name=$(echo $p_name | perl -ne '/(.+)_S-(\w+)\.*/ && print $1 . "_P-" . $2')
   id=$(echo $p_name | perl -ne '/(.+)_S-(\w+)\.*/ && print $2')
   if [ -n "$id" ] ; then
     p_id="P-$id"
     p_dir=$(mdfind "kMDItemDisplayName == *$p_id")
     if [ -d "$p_dir" ] ; then
      echo $p_dir
    fi
   else
     echo "Err: no id $id"
     exit 1
   fi
 else
   echo "Err: no p_file $p_file"
   exit 1
fi

