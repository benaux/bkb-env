#!/bin/sh

# in project

inp="$1"

prj_path=
if [ -n "$inp" ] ; then
   prj_path="$inp"
else
   prj_path=$(pwd)
fi 

prj_name=$(basename "$prj_path")

id=$(echo "$prj_name" | perl -ne '/(.+)_P-(\w+)\.*/ && print $2')

src_file=$(mdfind "kMDItemDisplayName == *S-${id}.*")

if [ -f "$src_file" ] ; then

  src_parent=$(dirname $src_file)
  src_fname=$(basename $src_file)

   src_dir=$(echo $src_fname | perl -ne '/(.+)_S-(\w+)\.*/ && print $1')

   if [ -n "$src_dir" ] ; then
      src_path=$src_parent/$src_dir
      if [ -d "$src_path" ] ; then
         echo $src_path
       else
         echo "Err: no src_path in $src_path"
         exit 1
      fi
    else
      echo "Err: no src_dir in $src_dir"
      exit 1
   fi
 else
   echo "Err: no src_file in $src_file"
   exit 1
fi

