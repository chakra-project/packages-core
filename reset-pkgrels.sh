#!/bin/bash
# GPL - jan.mette@berlin.de

#
# setup
#
_script_name="RESET PKGRELS"
_build_arch="$_arch"
_cur_repo=`pwd | awk -F '/' '{print $NF}'`
_needed_functions="config_handling helpers messages"
_available_pkglists=`cat _buildscripts/${_cur_repo}-${_build_arch}-pkgs.conf | grep "_" | cut -d "=" -f 1 | awk 'BEGIN {FS="_"} {print $NF}' | sed '/^$/d'`
# load functions
for subroutine in ${_needed_functions}
do
    source _buildscripts/functions/${subroutine}
done

#
# main
#
decrease_pkgrels()
{
        [ -n "$MODE" ] || error "you need to specify a package list defined in _/buildsystem/${_cur_repo}-${_build_arch}-pkgs.conf\n -> ${_available_pkglists}"
	
	case "$MODE" in
		all)
			title2 "Resetting all pkgrels"
			for module in ${whattodo[*]}
			do
			status_start "$module"
			pushd $module &>/dev/null

			REL=1
			while [ $REL -le 20 ]
			do
				sed -i -e "s/\<pkgrel=$REL.*\>/pkgrel=1/g" PKGBUILD
				
				REL=$(( $REL + 1 ))
			done

			popd &>/dev/null
			status_done
			done
		;;
		
		support)
			title2 "Resetting support pkgrels"
			for module in ${whattodo[*]}
			do
			status_start "$module"
			pushd $module &>/dev/null

			REL=1
			while [ $REL -le 20 ]
			do
				sed -i -e "s/\<pkgrel=$REL.*\>/pkgrel=1/g" PKGBUILD
				
				REL=$(( $REL + 1 ))
			done

			popd &>/dev/null
			status_done
			done
		;;

		qt)
			title2 "Resetting Qt pkgrels"
			for module in ${whattodo[*]}
			do
			status_start "$module"
			pushd $module &>/dev/null

			REL=1
			while [ $REL -le 20 ]
			do
				sed -i -e "s/\<pkgrel=$REL.*\>/pkgrel=1/g" PKGBUILD
				
				REL=$(( $REL + 1 ))
			done

			popd &>/dev/null
			status_done
			done
		;;
		
		kde)
			title2 "Resetting KDE pkgrels"
			for module in ${whattodo[*]}
			do
			status_start "$module"
			pushd $module &>/dev/null

			REL=1
			while [ $REL -le 20 ]
			do
				sed -i -e "s/\<pkgrel=$REL.*\>/pkgrel=1/g" PKGBUILD
				
				REL=$(( $REL + 1 ))
			done

			popd &>/dev/null
			status_done
			done
		;;
		
		tools)
			title2 "Resetting tool pkgrels"
			for module in ${whattodo[*]}
			do
			status_start "$module"
			pushd $module &>/dev/null

			REL=1
			while [ $REL -le 20 ]
			do
				sed -i -e "s/\<pkgrel=$REL.*\>/pkgrel=1/g" PKGBUILD
				
				REL=$(( $REL + 1 ))
			done

			popd &>/dev/null
			status_done
			done
		;;
	esac         
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
whattodo=($(eval echo "\${_build_${_cur_repo}_${MODE}[@]}"))

decrease_pkgrels

title "All done"
newline
