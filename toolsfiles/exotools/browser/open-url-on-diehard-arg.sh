#!/bin/sh

tools=$HOME/tools

url="$1"

/usr/bin/ssh bkb@diehard.fritz.box "\$HOME/tools/moreutils/chrome/open-url.py '$url'"
