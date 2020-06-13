#!/bin/bash
# vim:ts=4:noet

n=/dev/null
d=${1:-dirtree}
mf(){ if [[ "$1" =~ ^.+/$ ]]; then mkdir -p "$1"; else mkdir -p "$(dirname "$1")"; echo "$1" > "$1"; fi;}

mkdir "$d"
pushd $_ >$n

mf abc/a1
mf abc/a2
mf abc/empty/
mf abc/def/foo/bar1
mf abc/def/foo/bar2
mf abc/def/ghk/b1
mf abc/def/ghk/b2
mf abc/def/ghk/bbb8
mf abc/def/ghk/bbb9
mf abc/def/zum/bar0
mf abc/def/zum/bar9

mf abc/def/ghk/mul/bar/fiv99
mf abc/def/ghk/mul/bar/zi---11

popd >$n
find "$d"
tree "$d"
