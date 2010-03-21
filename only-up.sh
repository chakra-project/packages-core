#!/bin/bash
# GPL - philm@chakra-project.org

#
# setup
#
_script_name="UPLOAD PACKAGES"
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
sync_up()
{
        export RSYNC_PASSWORD=`echo $_rsync_pass`
        
        # move new packages from $ROOT/repos/$REPO/build into thr repo dir 
        title2 "adding new packages"
        mv -v _repo/build/*.pkg.tar.gz _repo/repo/

        # sync local -> server
        title2 "upload pkgs to server"
	rsync -avh --progress --delay-updates _repo/repo/ $_rsync_user@$_rsync_server::$_rsync_dir
}

#
# startup
#
title "${_script_name} - $_cur_repo"

check_configs
load_configs

check_rsync
check_accounts

time sync_up

title "All done"
newline
