#!/bin/sh

tools=$HOME/tools

url=$($tools/moreutils/firefox/geturl.py)

ssh bkb@diehard.fritz.box "\$HOME/tools/moreutils/chrome/open-url.py '$url'"
