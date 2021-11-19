#!/bin/bash sourced
## Provides tests for bash_ut_api_value_predicate functions.
## 

[ -z "$bash_ut_api_value_predicate_tests_p" ] || return 0

bash_ut_api_value_predicate_tests_p=t

##

source bash_ut_api_internal_test_util.functions.sh

source bash_ut_api_test_run.functions.sh

export CROAK_LOD=0

##

function test_is_value_predicate_expression__arg_count_0__args_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression 2>&1) || rc_actual=$?

	local result_expected_head="$(realpath "${BASH_SOURCE/.tests./.functions.}"): line "
	local result_expected_tail=": missing value for predicate_expression"

	assert "[[ '${result_actual}' == '${result_expected_head}'*'${result_expected_tail}' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_is_value_predicate_expression__arg_count_2__args_too_many() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression '[ -n ${1} ]' xyzzy 2>&1) || rc_actual=$?

	local result_expected_head="${this_script_name:?}: unexpected argument(s): "'xyzzy'

	assert "[[ '${result_actual}' == '${result_expected_head}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_uses_arg0() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression '${0}' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_uses_arg1_no_braces() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression '$1' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_type_builtin_n_function_n_identifier_n() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression '@' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_type_builtin_n_function_n_identifier_y() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression 'AB12' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_type_builtin_n_function_y_identifier_n() {(

	function always:true() { builtin true ; }

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression 'always:true' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
)}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_type_builtin_n_function_y_identifier_y() {(

	function always_true() { builtin true ; }

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression 'always_true' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
)}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_type_builtin_y_function_n_identifier_n() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression ':' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_type_builtin_y_function_n_identifier_y() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression 'false' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_type_builtin_y_function_y_identifier_n() {(

	function :() { builtin true ; } 

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression ':' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
)}

function test_is_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_type_builtin_y_function_y_identifier_y() {(

	function true() { builtin true ; }

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression 'true' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
)}

function test_is_value_predicate_expression__arg_count_1__operand_count_1__predicate_expression_uses_arg1() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression '${1}' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_1__predicate_expression_uses_arg9() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression '${9}' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_2__predicate_expression_uses_arg1_arg2() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression '[ ${1} = ${2} ]' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_is_value_predicate_expression__arg_count_1__operand_count_2__predicate_expression_uses_arg3_arg4() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression '[ ${3} -gt ${4} ]' 2>&1) || rc_actual=$?

	assert "[[ '${result_actual}' == '' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_0__args_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression 2>&1) || rc_actual=$?

	local result_expected_head="$(realpath "${BASH_SOURCE/.tests./.functions.}"): line "
	local result_expected_tail=": missing value for predicate_expression"

	assert "[[ '${result_actual}' == '${result_expected_head}'*'${result_expected_tail}' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_2__args_too_many() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression '[ -n ${1} ]' xyzzy 2>&1) || rc_actual=$?

	local result_expected_head="${this_script_name:?}: unexpected argument(s): "'xyzzy'

	assert "[[ '${result_actual}' == '${result_expected_head}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_uses_nonarg() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression AB12 2>&1) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s): not a value predicate expression: "'AB12'

	assert "[[ '${result_actual}' == '${result_expected}'* ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_1__operand_count_0__predicate_expression_uses_arg0() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression '${0}' 2>&1) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s): not a value predicate expression: "'${0}'

	assert "[[ '${result_actual}' == '${result_expected}'* ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_1__operand_count_1__predicate_expression_uses_arg1() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression '${1}' 2>&1) || rc_actual=$?

	local result_expected="1"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_1__operand_count_3__predicate_expression_uses_arg3() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression '${3}' 2>&1) || rc_actual=$?

	local result_expected="3"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_1__operand_count_9__predicate_expression_uses_arg9() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression '${9}' 2>&1) || rc_actual=$?

	local result_expected="9"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_1__operand_count_1__predicate_expression_uses_arg1_arg1() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression '[ 1 -le "${1}" -a "${1}" -le 5 ]' 2>&1) || rc_actual=$?

	local result_expected="1"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_1__operand_count_3__predicate_expression_uses_arg2_arg3() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression '[ 1 -le "${2}" -a "${3}" -le 5 ]' 2>&1) || rc_actual=$?

	local result_expected="3"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_max_operand_count_of_value_predicate_expression__arg_count_1__operand_count_9__predicate_expression_uses_arg1_arg9() {

	local result_actual= rc_actual=0
	result_actual=$(max_operand_count_of_value_predicate_expression '[ 1 -le "${1}" -a "${9}" -le 5 ]' 2>&1) || rc_actual=$?

	local result_expected="9"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_is_value_predicate_expression_with_max_operand_count__arg_count_0__args_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression_with_max_operand_count 2>&1) || rc_actual=$?

	local result_expected_head="$(realpath "${BASH_SOURCE/.tests./.functions.}"): line "
	local result_expected_tail=": missing value for operand_count"

	assert "[[ '${result_actual}' == '${result_expected_head}'*'${result_expected_tail}' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_is_value_predicate_expression_with_max_operand_count__arg_count_1__args_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression_with_max_operand_count 9 2>&1) || rc_actual=$?

	local result_expected_head="$(realpath "${BASH_SOURCE/.tests./.functions.}"): line "
	local result_expected_tail=": missing value for predicate_expression"

	assert "[[ '${result_actual}' == '${result_expected_head}'*'${result_expected_tail}' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_is_value_predicate_expression_with_max_operand_count__arg_count_3__args_too_many() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression_with_max_operand_count 9 '[ -n ${1} ]' xyzzy 2>&1) || rc_actual=$?

	local result_expected_head="${this_script_name:?}: unexpected argument(s): "'xyzzy'

	assert "[[ '${result_actual}' == '${result_expected_head}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_is_value_predicate_expression_with_max_operand_count__arg_count_2__max_operand_count_specified_lt_actual() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression_with_max_operand_count 1 '[ -n ${2} ]' 2>&1) || rc_actual=$?

	local result_expected_head=""

	assert "[[ '${result_actual}' == '${result_expected_head}' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_is_value_predicate_expression_with_max_operand_count__arg_count_2__max_operand_count_specified_eq_actual() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression_with_max_operand_count 2 '[ -n ${2} ]' 2>&1) || rc_actual=$?

	local result_expected_head=""

	assert "[[ '${result_actual}' == '${result_expected_head}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_is_value_predicate_expression_with_max_operand_count__arg_count_2__max_operand_count_specified_gt_actual() {

	local result_actual= rc_actual=0
	result_actual=$(is_value_predicate_expression_with_max_operand_count 3 '[ -n ${2} ]' 2>&1) || rc_actual=$?

	local result_expected_head=""

	assert "[[ '${result_actual}' == '${result_expected_head}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__all_vars_set_by_outer_scopes_are_useful_to_the_predicate_itself() {

	local vars_not_useful=($(

		list_all_unexpected_non_test_vars_defined_in_this_scope
	))

	[[ ${#vars_not_useful} -eq 0 ]] ||

	fire_test_run_event assertion_failed vars_not_useful: {[ "${vars_not_useful[@]}" ]}
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_0__args_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count 2>&1) || rc_actual=$?

	local result_expected_head="$(realpath "${BASH_SOURCE/.tests./.functions.}"): line "
	local result_expected_tail=": missing value for operand_count"

	assert "[[ '${result_actual}' == '${result_expected_head}'*'${result_expected_tail}' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_1__args_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count 2>&1 1) || rc_actual=$?

	local result_expected_head="$(realpath "${BASH_SOURCE/.tests./.functions.}"): line "
	local result_expected_tail=": missing value for predicate_expression"

	assert "[[ '${result_actual}' == '${result_expected_head}'*'${result_expected_tail}' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_too_low() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		1 '[[ ${1} = ${2} ]]' 2>&1 A B C D E F) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s)"
	result_expected+=": not a rank-1 value predicate expression: "'[[ ${1} = ${2} ]]'

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_too_high() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		3 '[[ ${1} = ${2} ]]' 2>&1 A A B B C C) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s)"
	result_expected+=": not a rank-3 value predicate expression: "'[[ ${1} = ${2} ]]'

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_inferred__result_false() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		inferred '[[ ${1} = ${2} ]]' 2>&1 A A B B C D) || rc_actual=$?

	local result_expected=""

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_inferred__result_true() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		inferred '[[ ${1} = ${2} ]]' 2>&1 A A B B C C) || rc_actual=$?

	local result_expected=""

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 0 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_2__operand_count_1__values_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		1 '[[ -n ${1} ]]' 2>&1) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s)"
	result_expected+=": operand count exceeds value count: 1 vs. 0"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_3__operand_count_2__values_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		2 '[[ ${1} = ${2} ]]' 2>&1 A) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s)"
	result_expected+=": operand count exceeds value count: 2 vs. 1"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_7__operand_count_2__values_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		2 '[[ ${1} = ${2} ]]' 2>&1 A A B B C) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s)"
	result_expected+=": operand count exceeds value count remaining: 2 vs. 1"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_6__operand_count_3__values_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		3 '[[ ${1} = ${2} && ${2} = ${3} ]]' 2>&1 A A A B) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s)"
	result_expected+=": operand count exceeds value count remaining: 3 vs. 1"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_7__operand_count_3__values_too_few() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		3 '[[ ${1} = ${2} && ${2} = ${3} ]]' 2>&1 A A A B B) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s)"
	result_expected+=": operand count exceeds value count remaining: 3 vs. 2"

	assert "[[ '${result_actual}' == '${result_expected}' ]]"

	assert "[[ ${rc_actual:?} = 2 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_1__predicate_expression_malformed() {

	local result_actual= rc_actual=0
	result_actual=$(values_are_match_using_predicate_with_operand_count \
		1 '[[ -n ${1} ' 2>&1 A B C D E F) || rc_actual=$?

	local result_expected="${this_script_name:?}: invalid argument(s)"
	result_expected_head+=": not a value predicate expression: "'[[ -n ${1} '

	local result_expected_tail=""

#	assert "[[ '${result_actual}' == '${result_expected_head}'*'${result_expected_tail}' ]]"
#	#^-- FIXME: make it possible to pass malformed expressions to assert

	assert "[[ ${rc_actual:?} = 1 ]]"
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_1__predicate_expression_inconsistent() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_2__predicate_expression_malformed() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_2__predicate_expression_inconsistent() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__predicate_expression_malformed() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__predicate_expression_inconsistent() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_too_low() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_too_high() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_kw_min() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_kw_max() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_kw_all() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_malformed() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_unspecified() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_lt_operand_count__divides_evenly_n() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_lt_operand_count__divides_evenly_y() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_eq_operand_count__divides_evenly_y() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_gt_operand_count__divides_evenly_n() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__stride_gt_operand_count__divides_evenly_y() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_too_low() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_too_high() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_kw_min() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_kw_max() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_kw_all() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_malformed() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_unspecified() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__max_count_too_low() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__max_count_too_high() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__max_count_kw_min() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__max_count_kw_max() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__max_count_kw_all() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__max_count_malformed() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__max_count_unspecified() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_gt_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_eq_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__min_count_lt_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__match_count_lt_min_count_eq_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__match_count_lt_min_count_lt_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__match_count_eq_min_count_eq_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__match_count_eq_min_count_lt_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__match_count_gt_min_count_lt_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__match_count_gt_min_count_eq_max_count() {

	false # FIXME: implement this test
}

function test_values_are_match_using_predicate_with_operand_count__arg_count_8__operand_count_3__match_count_gt_max_count_gt_min_count() {

	false # FIXME: implement this test
}
