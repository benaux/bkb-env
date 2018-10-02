#!/bin/sh


get_url=$HOME/tools/lib/browser/get_url.sh

die () { echo $@; exit 1; }

conf=$HOME/.bkb.conf
[ -f "$conf" ] || die "Err: no bkb.conf to load"
source "$conf"

[ -f "$get_url" ] || die "Err: couldn't use lib $get_url"


url=$(sh "$get_url")
[ "$?" -eq 0 ] || die "$url"
[ -n "$url" ] || die "Err: no url"

ssh bkb@diehard "\$HOME/tools/moreutils/chrome/open-url.py '$url'"

