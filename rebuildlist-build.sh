#
# setup
#
curdir=`pwd`
repodir="_repo/repo"

_script_name="GEN REBUILD LIST"
_build_arch="$_arch"
_cur_repo=`pwd | awk -F '/' '{print $NF}'`
_needed_functions="config_handling messages"
# load functions
for subroutine in ${_needed_functions}
do
    source _buildscripts/functions/${subroutine}
done

#
# startup
#
title "${_script_name}"

check_configs
load_configs

if [ -z "$1" ]; then
	error "Usage: $0 <rebuild list>"
	newline
	exit
fi

list="$1"
startdir=$(pwd)
packages=`cat $startdir/_temp/rebuildlist-$list.txt | grep -v "$list"`

pushd $list
	../makepkg -si
popd

for pkg in $packages; do
	pushd $pkg
	../makepkg -si
	popd
done





















