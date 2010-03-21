#! /bin/bash

#   rebuildlist - list packages needing rebuilt for a soname bump
#
#   Copyright (c) 2009 by Allan McRae <allan@archlinux.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


if [ -z "$1" -o -z "$2" ]; then
	echo "Usage $0 <pkg directory> <library1> [<library2> ...]"
	exit
fi

directory=$1
shift

while [ -n "$1" ]; do
	grepexpr="$grepexpr -e ${1%%.so}.so"
	shift
done

startdir=$(pwd)
tmpdir=$(mktemp -d)
cd $tmpdir

for pkg in $(ls $directory/*.pkg.tar.gz); do
	pkg=${pkg##*\/}
	echo "Scanning $pkg"
	mkdir $tmpdir/extract
	cp $directory/$pkg $tmpdir/extract
	cd $tmpdir/extract
	tar -xf $directory/$pkg
	rm $pkg
	found=$(readelf --dynamic $(find -type f) 2>/dev/null | grep $grepexpr | wc -l)
	if [ $found -ne 0 ]; then
		echo ${pkg%-*-*-*} >> ../rebuildlist.txt
	fi
	cd ..
	rm -rf extract
done

cp $tmpdir/rebuildlist.txt $startdir
