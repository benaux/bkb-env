#!/bin/sh

moreutils=$HOME/aux/moreutils

url=$($moreutils/firefox/geturl.py)


$moreutils/chrome/open-url.py "$url"
