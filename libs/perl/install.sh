#!/bin/sh


perllib=$HOME/.perllib

[ -d "$perllib" ] || mkdir "$perllib/Aux"


for m in Aux/* ; do
	rm -f $perllib/$m
	base=${m%.*}
	rm -f $perllib/Aux/$base

	ln -s $(pwd)/$m $perllib/Aux/
done





