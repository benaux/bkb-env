#!/bin/sh

tools_dir=$HOME/aux/tools

screencapture_dimensions=""

screenshots_dir=$HOME/aux/sites/localhost/exo/screenshots

screenshot_url='http://skyfall.fritz.box/exo/screenshots/screenshot-paste.png'

#geturl=$($tools_dir/moreutils/firefox/geturl.py)

screencapture='/usr/sbin/screencapture'

die () { echo $@ ; exit 1 ; }

for tool in $screencapture ; do
  [ -f "$tool" ] || { 
    echo "Err: tool $tool not exist"
    exit 1
   } 
done

for dir in $tools_dir $screenshots_dir ; do
  [ -d "$dir" ] || { 
    echo "Err: dir $dir not exist"
    exit 1
   } 
done

screenshot=$screenshots_dir/screenshot-paste.png

rm -f $screenshot

${screencapture} $screenshot
#${screencapture} -R "$screencapture_dimensions" $screenshot


[ -f "$screenshot" ] || die "Err: there is no screenshot in $screenshot"


ssh bkb@diehard.fritz.box "\$HOME/aux/tools/moreutils/chrome/open-url.py '$screenshot_url'"

#ssh bkb@diehard.fritz.box "\$HOME/aux/tools/moreutils/chrome/open-url.py '$url'"
