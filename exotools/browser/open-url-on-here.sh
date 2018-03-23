#!/bin/sh

tools=$HOME/tools

url=$($tools/moreutils/firefox/geturl.py)


$tools/moreutils/chrome/open-url.py "$url"
