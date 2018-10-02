#!/bin/sh

foldername=$1



for foldername
do
    /usr/libexec/PlistBuddy -x -c Print ~/Library/Safari/Bookmarks.plist | \
    xmlstarlet sel --net -t -v "//key[.='Title']/following-sibling::string[.='$foldername']/parent::node()//key[.='URLString']/following-sibling::string[1]"
    echo    #print an newline after the last entry
done
