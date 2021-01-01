#!/bin/bash sourced
## Provides assert() and friends.
## 

[ -z "$bash_ut_api_assertion_functions_p" ] || return 0

bash_ut_api_assertion_functions_p=t

bash_ut_api_assertion_debug_p=

##

source bash_ut_api_value_predicate.functions.sh

source bash_ut_api_test_run.functions.sh

source failure_mode.functions.sh

##

function assert_value() { # predicate_expression value

	[ ${#} -eq 2 ] || (shift 1 ; croak "expected exactly 1 value; got ${#}") || return $?

	assert_values_are_match_using_predicate_with_operand_count 1 --stride all "${@}"
}

function assert_value_pair() { # predicate_expression value01 value02

	[ ${#} -eq 3 ] || (shift 1 ; croak "expected exactly 2 values; got ${#}") || return $?

	assert_values_are_match_using_predicate_with_operand_count 2 --stride all "${@}"
}

function assert_value_triple() { # predicate_expression value01 value02 value03

	[ ${#} -eq 4 ] || (shift 1 ; croak "expected exactly 3 values; got ${#}") || return $?

	assert_values_are_match_using_predicate_with_operand_count 3 --stride all "${@}"
}

function assert_value_quad() { # predicate_expression value01 value02 value03 value04

	[ ${#} -eq 5 ] || (shift 1 ; croak "expected exactly 4 values; got ${#}") || return $?

	assert_values_are_match_using_predicate_with_operand_count 4 --stride all "${@}"
}

function assert_each_value() { # predicate_expression [ option ... ] [ value ... ]

	assert_values_are_match_using_predicate_with_operand_count 1 --stride all "${@}"
}

function assert_each_value_pair() { # predicate_expression [ option ... ] [ value ... ]

	assert_values_are_match_using_predicate_with_operand_count 2 --stride all "${@}"
}

function assert_each_value_triple() { # predicate_expression [ option ... ] [ value ... ]

	assert_values_are_match_using_predicate_with_operand_count 3 --stride all "${@}"
}

function assert_each_value_quad() { # predicate_expression [ option ... ] [ value ... ]

	assert_values_are_match_using_predicate_with_operand_count 4 --stride all "${@}"
}

function assert_values_are_match_using_predicate() { # predicate_expression [ option ... ] [ value ... ]

	"${FUNCNAME:?}"_with_operand_count inferred "$@"
}

function assert_values_are_match_using_predicate_with_operand_count() { # operand_count predicate_expression [ option ... ] [ value ... ]

	local operand_count=${1:?missing value for operand_count} ; shift 1

	local predicate_expression=${1:?missing value for predicate_expression} ; shift 1

	( 
		set -e ; set -o pipefail 2>&- || :

		values_are_match_using_predicate_with_operand_count "${operand_count:?}" "${predicate_expression:?}" "${@}"
	) ||

	fire_test_run_event assertion_failed predicate: "${predicate_expression}" operand_count: "${operand_count:?}" values: "( ${@} )"
}

function assert() { # predicate_expression_fragment ...

	( 
		set -e ; set -o pipefail 2>&- || :

		eval "${@}"
	) ||

	fire_test_run_event assertion_failed predicate: "${@}"
}

