#!/bin/bash sourced
## Provides functions pertaining to a test run.
## 

[ -z "$bash_ut_api_test_run_functions_p" ] || return 0

bash_ut_api_test_run_functions_p=t

bash_ut_api_test_run_debug_p=

##

source bash_ut_api_assertion.functions.sh

source failure_mode.functions.sh

##

function run_tests_in_each_file() { # [ test_script_fpn ... ]

	local this_test_script_set=( "$@" ) ; shift $#

	local this_test_script_fpn=

	for this_test_script_fpn in "${this_test_script_set[@]}" ; do

		run_tests_in_file "${this_test_script_fpn:?}" || return $?
	done
}

function run_tests_in_file() { # test_script_fpn

	local this_test_script_fpn=${1:?missing value for test_script_fpn} ; shift 1

	[ $# -eq 0 ] || croak_unexpected_arguments "$@" || return $?

	local this_test_script_dpn= this_test_script_fbn=

	this_test_script_fpn=$(realpath "${this_test_script_fpn:?}")

	this_test_script_dpn=$(dirname  "${this_test_script_fpn:?}")
	this_test_script_fbn=$(basename "${this_test_script_fpn:?}")

	if [ ! -e "${this_test_script_fpn:?}" ] ; then

		croak "test script does not exist: ${this_test_script_fpn:?}; skipping" || :

		return 0
	else
	(
		set -e

		set -o pipefail 2>&- || :

		##

		# if the directory of this test script is not in PATH...

		for _1_ in "$(dirname "$(realpath "${this_test_script_fpn:?}")")" ; do

			if [[ ::"${PATH}":: != *:"${_1_:?}":* ]] ; then

				PATH=${_1_:?}${PATH:+:}${PATH} # put it there
			fi
		done

		##

		fire_test_run_event beginning &&

		( source "${this_test_script_fpn:?}" && run_tests_in_scope ) &&

		fire_test_run_event completed rc: $? ||
		fire_test_run_event completed rc: $? ;
	)
	fi
}

function run_tests_in_scope() { #

	local this_test_name=

	call_function_if_defined_in_test_scope set_up_test_scope || return $?

	for this_test_name in $(list_all_tests_in_scope) ; do

		run_test "${this_test_name:?}" || return $?
	done

	call_function_if_defined_in_test_scope tear_down_test_scope || return $?
}

function run_tests() { #

	run_tests_in_scope "$@"
}

function run_test() { # test_name

	local this_test_name=${1:?missing value for test_name} ; shift 1

	[ $# -eq 0 ] || croak_unexpected_arguments "$@" || return $?

	##

	(
		call_function_if_defined_in_test_scope set_up_test &&

		{
			fire_test_run_event beginning &&

			( "${this_test_name:?}" ) &&

			fire_test_run_event completed rc: $? ||
			fire_test_run_event completed rc: $? ;
		} &&

		call_function_if_defined_in_test_scope tear_down_test ;
	)

	#^-- by design: overall test scope is protected from side effects pertaining to just this test
}

function list_all_tests_in_scope() { #

	declare -F | perl -pe 's#declare\s+-f\s+##' | (egrep '^test' || :) | LC_ALL=C sort -u
}

function fire_test_run_event() { # event_type [ ( key: value ) ... ]

	local event_type=${1:?missing value for event_type} ; shift 1

	#caller_context this_test_name

	##

	case "${event_type:?}" in
	beginning|completed|failed|*_failed)

		if [ -n "${this_test_name}" ] ; then

			echo ">>> test name: ${this_test_name:?} event: ${event_type:?}" "$@"

			! [ "${event_type:?}" = completed ] || echo ">>> "
		else
			echo ">>> test_file name: ${this_test_script_fpn:?} event: ${event_type:?}" "$@"

			echo ">>> "
		fi
		;;

	*|'')
		croak "unexpected event type: ${event_type}"
		return 2
		;;
	esac
}

function call_function_if_defined_in_test_scope() { # function_name [ arg ... ] #FIXME: test this

	local function_name=${1:?missing value for function_name} ; shift 1

	[[ $(type -t "${function_name:?}") =~ ^(builtin|function)$ ]] || return 0

	##

	"${function_name:?}" "$@" || fire_test_run_event "${FUNCNAME:?}_failed" args: "( ${@} )"

	#^-- by design: caller scope is *not* protected from side effects
}

function abort_remaining_tests_in_scope() { # [ reason [ detail ... ] ] #FIXME: test this

	this_test_name= # forcibly pop back into test scope

	local reason=${1:-unspecified} ; [ $# -lt 1 ] || shift 1

	fire_test_run_event "${FUNCNAME:?}" reason: "${reason:?}" "$@"

	return 2
}

function skip_remaining_tests_in_scope() { # [ reason [ detail ... ] ] #FIXME: test this

	this_test_name= # forcibly pop back into test scope

	local reason=${1:-unspecified} ; [ $# -lt 1 ] || shift 1

	fire_test_run_event "${FUNCNAME:?}" reason: "${reason:?}" "$@"

	return 0
}
