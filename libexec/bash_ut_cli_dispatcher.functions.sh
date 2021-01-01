#!/bin/bash sourced
## Provides function bash_ut_cli_dispatcher() and friends.
## 

[ -z "$bash_ut_cli_dispatcher_functions_p" ] || return 0

bash_ut_cli_dispatcher_functions_p=t

bash_ut_cli_dispatcher_debug_p=

##

source "bash_ut_cli_action_path.functions.sh"
source "bash_ut_cli_action_run.functions.sh"

##

function bash_ut_cli_dispatcher() { # ... 

	local action=
	local action_args=()

	while [ $# -gt 0 ] ; do
	case "${1}" in
	-*)
		echo 1>&2 "${FUNCNAME:?}: unrecognized/unsupported option: ${1}"
		return 2
		;;

	eval|path|run)
		action=${1:?}

		shift 1
		break
		;;

	*|'')
		echo 1>&2 "${FUNCNAME:?}: unrecognized/unsupported action: ${1:-''}"
		return 2
		;;
	esac;done

	action=${action:-run}

	action_args+=( "$@" ) ; shift $#

	local action_cmd=()

	case "${action:?}" in
	eval)
		action_cmd=( eval )
		;;

	path|run)
		action_cmd=( bash_ut_cli_action_"${action:?}" )
		;;

	*)
		echo 1>&2 "${FUNCNAME:?}: unrecognized/unsupported action: ${action:?}"
		return 2
		;;
	esac

	(
		set -- "${action_cmd[@]}" "${action_args[@]}"

		unset action
		unset action_args
		unset action_cmd

		"$@"
	)
}

