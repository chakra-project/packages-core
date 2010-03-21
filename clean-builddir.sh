#!/bin/bash
# GPL - jan.mette@berlin.de

#
# setup
#
_script_name="CLEAN BUILD PKGS"
_build_arch="$_arch"
_cur_repo=`pwd | awk -F '/' '{print $NF}'`
_needed_functions="config_handling messages"
# load functions
for subroutine in ${_needed_functions}
do
    source _buildscripts/functions/${subroutine}
done

#
# main
#
cleanup_pkgs() { 
		title2 "Cleaning build packages"

		pushd _repo/build/ &>/dev/null

		status_start "_repo/build"
		rm -rf *.tar.gz &>/dev/null
		status_done
        
		popd &>/dev/null
}

#
# startup
#
title "${_script_name}"

check_configs
load_configs

cleanup_pkgs

title "All done"
newline
