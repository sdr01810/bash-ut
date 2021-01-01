#!/bin/bash sourced
## Provides function bash_ut_cli_action_path() and friends.
## 

[ -z "$bash_ut_cli_action_path_functions_p" ] || return 0

bash_ut_cli_action_path_functions_p=t

bash_ut_cli_action_path_debug_p=

##

function bash_ut_cli_action_path() { # [ file_or_directory_rpn ... ]

	local args=( "$@" ) ; shift $# 

	[ ${#args[@]} -gt 0 ] || args+=( bin )

	local installation_dpn=$(dirname "$(dirname "${BASH_SOURCE:?}")")

	local result= x1_rpn=

	for x1_rpn in "${args[@]}" ; do

		result="${result}${result:+:}${installation_dpn:?}/${x1_rpn}"
	done

	echo "${result}"
}
