#!/bin/bash sourced
## Provides functions that evaluate value predicates.
## 

[ -z "$bash_ut_api_value_predicate_functions_p" ] || return 0

bash_ut_api_value_predicate_functions_p=t

bash_ut_api_value_predicate_debug_p=

##

source failure_mode.functions.sh

##

function is_value_predicate_expression() { # predicate_expression

	local predicate_expression=${1:?missing value for predicate_expression} ; shift 1

	[ $# -eq 0 ] ||	croak_unexpected_arguments "$@" || return $?

	##

	[[ "${predicate_expression:?}" =~ \$\{[1-9]} ]] ||

	is_value_predicate_function_name "${predicate_expression:?}"
}

function is_value_predicate_function_name() { # function_name

	local function_name=${1:?missing value for function_name} ; shift 1

	[ $# -eq 0 ] ||	croak_unexpected_arguments "$@" || return $?

	##

	[[ $(type -t "${function_name:?}") =~ ^(builtin|function)$ ]]
}

function max_operand_count_of_value_predicate_expression() { # predicate_expression

	local predicate_expression=${1:?missing value for predicate_expression} ; shift 1

	[ $# -eq 0 ] ||	croak_unexpected_arguments "$@" || return $?

	is_value_predicate_expression "${predicate_expression:?}" ||
	croak_invalid_argument "not a value predicate expression: ${predicate_expression:?}" || return $?

	##

	local i= result= did_determine_max_operand_count_p=

	for i in 9 8 7 6 5 4 3 2 1 ; do

		if [[ "${predicate_expression:?}" =~ \$\{$i} ]] ; then

			did_determine_max_operand_count_p=t

			result=$i ; break
		fi
	done

	if [[ -n ${result} ]] ; then

		:
	else
	if [[ $(type -t "${predicate_expression:?}") =~ ^(builtin|function)$ ]] ; then

		result="-1" # indeterminate
	else
		result="-2" # can't happen
	fi;fi

	echo "${result}"

	[[ -n ${did_determine_max_operand_count_p} ]]
}

function is_value_predicate_expression_with_max_operand_count() { # operand_count predicate_expression

	local operand_count=${1:?missing value for operand_count} ; shift 1

	local predicate_expression=${1:?missing value for predicate_expression} ; shift 1

	[ $# -eq 0 ] ||	croak_unexpected_arguments "$@" || return $?

	##

	local max_operand_count=$(

		max_operand_count_of_value_predicate_expression "${predicate_expression:?}"
	)

	[ "${operand_count:?}" -ge "${max_operand_count}" ]
}

function is_value_predicate_expression_with_operand_count() { # operand_count predicate_expression

	local operand_count=${1:?missing value for operand_count} ; shift 1

	local predicate_expression=${1:?missing value for predicate_expression} ; shift 1

	[ $# -eq 0 ] ||	croak_unexpected_arguments "$@" || return $?

	##

	local max_operand_count=$(

		max_operand_count_of_value_predicate_expression "${predicate_expression:?}"
	)

	[ "${operand_count:?}" -eq "${max_operand_count}" ]
}

function values_are_match_using_predicate() { # predicate_expression [option ...] [ value ... ]

	"${FUNCNAME:?}"_with_max_operand_count inferred "$@"
}

function values_are_match_using_predicate_with_operand_count() { # operand_count predicate_expression [option ...] [ value ... ]

	local operand_count=${1:?missing value for operand_count} ; shift 1

	local predicate_expression=${1:?missing value for predicate_expression} ; shift 1

	local did_infer_operand_count_p=

	if [ "${operand_count:-inferred}" = inferred ] ; then

		operand_count=$(max_operand_count_of_value_predicate_expression "${predicate_expression:?}") || return $?

		did_infer_operand_count_p=t
	fi

	[[ ${operand_count:?} -ge 1 ]] ||
	croak_invalid_argument "operand count: ${operand_count:?}" || return $?

	[[ ${operand_count:?} -le 9 ]] ||
	croak_unsupported_argument "operand count: ${operand_count:?}" || return $?

	[[ -n ${did_infer_operand_count_p} ]] ||
	is_value_predicate_expression_with_operand_count ${operand_count:?} "${predicate_expression:?}" ||
	croak_invalid_argument "not a rank-${operand_count:?} value predicate expression: ${predicate_expression}" || return $?

	##

	local min_count= max_count= stride=

	while [ $# -gt 0 ] ; do
	case "${1}" in
	--min-count)
		[[ -z ${min_count} ]] ||
		croak_option_already_specified "${1:?}" || return $?

		min_count=${2}
		shift 2
		break
		;;

	--max-count)
		[[ -z ${max_count} ]] ||
		croak_option_already_specified "${1:?}" || return $?

		max_count=${2}
		shift 2
		break
		;;

	--stride)
		[[ -z ${stride} ]] ||
		croak_option_already_specified "${1:?}" || return $?

		stride=${2}
		shift 2
		break
		;;

	-*)
		croak_unsupported_option "${1:?}" || return $?
		;;

	--)
		shift 1
		break
		;;

	*|'')
		break
		;;
	esac;done

	[[ ${operand_count:?} -le $# ]] ||
	croak_invalid_argument "operand count exceeds value count: ${operand_count:?} vs. $#" || return $?

	##

	: ${stride:=all}

	! [[ ${stride:?} = min ]] || stride=1

	! [[ ${stride:?} = max ]] || stride=$#

	! [[ ${stride:?} = all ]] || stride=${operand_count:?} # sic

	##

	: ${min_count:=all} ${max_count:=all}

	! [[ ${min_count:?} = min ]] || min_count=0
	! [[ ${max_count:?} = min ]] || max_count=0

	! [[ ${min_count:?} = max ]] || min_count=$(( $# / ${stride:?} ))
	! [[ ${max_count:?} = max ]] || max_count=$(( $# / ${stride:?} ))

	! [[ ${min_count:?} = all ]] || min_count=$(( $# / ${stride:?} ))
	! [[ ${max_count:?} = all ]] || max_count=$(( $# / ${stride:?} ))

	[[ 0 -le ${min_count:?} && ${min_count:?} -le $# ]] ||
	croak_invalid_argument "min_count is not in the range [0..value_count]: ${min_count:?}" || return $?

	[[ 0 -le ${max_count:?} && ${max_count:?} -le $# ]] ||
	croak_invalid_argument "max_count is not in the range [0..value_count]: ${max_count:?}" || return $?

	[[ ${min_count:?} -le ${max_count:?} ]] ||
	croak_invalid_argument "min count exceeds max count: ${min_count:?} vs. ${max_count:?}" || return $?

	##

	local count=0

	local predicate_expression_is_function_name_p=$(
	is_value_predicate_function_name "${predicate_expression:?}" && echo t)

	while [[ $# -gt 0 && ${count:?} -le ${max_count:?} ]] ; do

		[[ ${operand_count:?} -le $# ]] ||
		croak_invalid_argument "operand count exceeds value count remaining: ${operand_count:?} vs. $#" || return $?

		(
			set -e ; set -o pipefail 2>&- || :

			case "${operand_count:?}" in
			1)
				set -- "${1}"
				;;
			2)
				set -- "${1}" "${2}"
				;;
			3)
				set -- "${1}" "${2}" "${3}"
				;;
			4)
				set -- "${1}" "${2}" "${3}" "${4}"
				;;
			5)
				set -- "${1}" "${2}" "${3}" "${4}" "${5}"
				;;
			6)
				set -- "${1}" "${2}" "${3}" "${4}" "${5}" "${6}"
				;;
			7)
				set -- "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}"
				;;
			8)
				set -- "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}"
				;;
			9)
				set -- "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}"
				;;
			*)
				croak_cannot_happen "unrecognized/unsupported operand count: ${operand_count:?}" || return $?
				;;
			esac

			unset count
			unset min_count
			unset max_count

			unset did_infer_operand_count_p
			unset operand_count
			unset stride

			local this_expression=${predicate_expression:?}

			if [[ -n ${predicate_expression_is_function_name_p} ]] ; then

				unset predicate_expression_is_function_name_p
				unset predicate_expression

				"${this_expression:?}" "${@}"
			else
				unset predicate_expression_is_function_name_p
				unset predicate_expression

				eval "${this_expression:?}"
			fi

		) && (( count += 1 )) || :

		shift ${stride:?} || break
	done

	[[ ${min_count:?} -le ${count:?} && ${count:?} -le ${max_count:?} ]]
}

##

function values_are_equal() { # [ value ... ]

	values_are_match_using_predicate_with_operand_count 2 '[[ "${1}" == "${2}" ]]' "${@}"
}

function values_are_not_equal() { # [ value ... ]

	values_are_match_using_predicate_with_operand_count 2 '[[ "${1}" != "${2}" ]]' "${@}"
}

##

function value_is_null() { # value

	[ $# -eq 1 ] || (shift 1 ; croak_unexpected_arguments "$@") || return $?

	values_are_null "$@"
}

function value_is_not_null() { # value

	[ $# -eq 1 ] || (shift 1 ; croak_unexpected_arguments "$@") || return $?

	values_are_not_null "$@"
}

function values_are_null() { # [ value ... ]

	values_are_match_using_predicate_with_operand_count 1 '[[ -z "${1}" ]]' "${@}"
}

function values_are_not_null() { # [ value ... ]

	values_are_match_using_predicate_with_operand_count 1 '[[ -n "${1}" ]]' "${@}"
}

##

