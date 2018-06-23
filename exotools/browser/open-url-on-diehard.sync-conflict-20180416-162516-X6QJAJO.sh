#!/bin/sh

moreutils=$HOME/aux/moreutils

url=$($moreutils/firefox/geturl.py)

ssh bkb@diehard.fritz.box "\$HOME/aux/moreutils/chrome/open-url.py '$url'"
