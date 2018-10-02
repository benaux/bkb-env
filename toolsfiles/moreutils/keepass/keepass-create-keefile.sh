#!/bin/sh

profile=ben_2P0a.pwc-ii 

keefile=$1 

[ -n "$keefile" ] || { echo "usage: <keepass name> (eg. 'keepass_180310')" ; exit 1; } 


twikpw $profile "keefile/$keefile"
