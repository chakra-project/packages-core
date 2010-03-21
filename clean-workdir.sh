#!/bin/bash
# GPL - jan.mette@berlin.de

#
# setup
#
_script_name="CLEAN WORK DIRECTORY"
_build_arch="$_arch"
_cur_repo=`pwd | awk -F '/' '{print $NF}'`
_needed_functions="config_handling messages"
_available_pkglists=`cat _buildscripts/${_cur_repo}-${_build_arch}-pkgs.conf | grep "_" | cut -d "=" -f 1 | awk 'BEGIN {FS="_"} {print $NF}' | sed '/^$/d'`
# load functions
for subroutine in ${_needed_functions}
do
    source _buildscripts/functions/${subroutine}
done

#
# main
#
cleanup_src()
{ 
        [ -n "$MODE" ] || error "you need to specify a package list defined in _/buildsystem/${_cur_repo}-${_build_arch}-pkgs.conf\n -> ${_available_pkglists}"

	newline
	title2 "Cleaning workdir"
	for module in ${whattodo[*]}
	do
		status_start "${module}"
		pushd $module &>/dev/null
		rm -rf pkg src dbg hdr &>/dev/null
		popd &>/dev/null
		status_done
	done
}

#
# startup
#
title "${_script_name}"

check_configs
load_configs

MODE=`echo $1`

# we take the repo name + the job/stage to reconstruct the variable name
# in $repo_pkgs.cfg and echo its contents... damn, eval is evil ;)

	if [ "$_cur_repo" = "core" ] ; then
	whattodo=($(eval echo "\${_build_core_${MODE}[@]}"))

	elif [ "$_cur_repo" = "core-testing" ] ; then
	whattodo=($(eval echo "\${_build_core_testing_${MODE}[@]}"))

	elif [ "$_cur_repo" = "platform" ] ; then
	whattodo=($(eval echo "\${_build_platform_${MODE}[@]}"))

	elif [ "$_cur_repo" = "platform-testing" ] ; then
	whattodo=($(eval echo "\${_build_platform_testing_${MODE}[@]}"))

	elif [ "$_cur_repo" = "desktop" ] ; then
	whattodo=($(eval echo "\${_build_desktop_${MODE}[@]}"))

	elif [ "$_cur_repo" = "desktop-testing" ] ; then
	whattodo=($(eval echo "\${_build_desktop_testing_${MODE}[@]}"))

	elif [ "$_cur_repo" = "apps" ] ; then
	whattodo=($(eval echo "\${_build_apps_${MODE}[@]}"))

	elif [ "$_cur_repo" = "apps-testing" ] ; then
	whattodo=($(eval echo "\${_build_apps_testing_${MODE}[@]}"))

	fi

cleanup_src

title "All done"
newline
