#!/bin/sh

# in project

target="$1"

cwd="$2"

[ -n "$target" ] || { echo "usage:<target>" ; exit 1; }

[ -n "$cwd" ] || cwd=$(pwd)

dircwd=$(dirname $cwd)

basedir=$(basename $cwd)

p_file=$(echo $dircwd/.${basedir}_*.txt)

[ -f "$p_file" ] || p_file=$(echo $dircwd/${basedir}_*.txt)

[ -f "$p_file" ] || {
   echo "Err: no p_file $p_file"
   exit 1
 }


p_name=$(basename $p_file)

# name=$(echo $p_name | perl -ne '/(.+)_S-(\w+)\.*/ && print $1 . "_P-" . $2')
id=$(echo $p_name | perl -ne '/(.+)_[A-Z]-(\w+)\.*/ && print $2')

if [ -n "$id" ] ; then
   uptarget=$(perl -e 'print(uc($ARGV[0]))' $target)

   target_id="$uptarget-$id.txt"
   target_path=$(mdfind "kMDItemDisplayName == *$target_id")

 [ -e "$target_path" ] || { echo "Err: not found target_path $target_path in id $target_id" ; exit 1; }

 target_dir=$(dirname $target_path)
 target_name=$(basename $target_path)

  folder=$(echo $target_name | perl -ne '/(.+)_[A-Z]-(\w+)\.*/ && print $1')

 if [ -f "$target_path" ] ; then
   if [ -d "$target_dir/$folder" ] ; then
     echo "$target_dir/$folder"
   else
     echo "Err: no target folder in $target_dir/$folder"
     exit 1
   fi
 elif [ -d "$target_path" ] ; then
  echo $target_path
 fi
else
 echo "Err: no id $id"
 exit 1
fi


