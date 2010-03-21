#!/bin/bash
# GPL - jan.mette@berlin.de

#
# setup
#
_script_name="PACKAGE LISTS"
_build_arch="$_arch"
_cur_repo=`pwd | awk -F '/' '{print $NF}'`
_needed_functions="config_handling helpers messages"
# load functions
for subroutine in ${_needed_functions}
do
    source _buildscripts/functions/${subroutine}
done

#
# main
#
show_pkglists()
{
	clear
	echo " "
	echo -e "$_g >$_W $_script_name$_n"
	cat _buildscripts/${_cur_repo}_pkgs.conf | sed 's/"/ /g'
	echo " "
}

#
# startup
#
check_configs
load_configs

get_colors
show_pkglists
