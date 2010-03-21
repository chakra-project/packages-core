#!/bin/bash
# GPL - jan.mette@berlin.de

#
# setup
#
_script_name="SYNC UP PACKAGES"
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
        mv -v _repo/build/*.pkg.* _repo/repo/

        # run repo-clean on it
        title2 "running repo-clean"
        repo-clean -m c -s _repo/repo/

        # create new pacman database
        title2 "creating pacman database"
	rm -rf _repo/repo/*.db.tar.gz
        pushd _repo/repo/
        repo-add $_cur_repo.db.tar.gz *.pkg.*
        popd

        # sync local -> server
        title2 "sync local -> server"
        rsync -avh --progress --delay-updates --delete-after _repo/repo/ $_rsync_user@$_rsync_server::$_rsync_dir
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