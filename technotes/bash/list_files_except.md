#!/bin/sh

find . -maxdepth 1 -type f  -not -iname '*.md' -exec rm -f {} \;
