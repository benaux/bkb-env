#!/bin/sh

os=$(uname)

here=$(dirname $0)

case "$os" in
  Darwin)
    osascript "$here/geturl.applescript"
    pbpaste
    ;;
  *)
    echo "Err: todo $os"
    exit 1
    ;;
esac

