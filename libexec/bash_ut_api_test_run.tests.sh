#!/bin/bash sourced
## Provides tests for bash_ut_api_test_run functions.
## 

[ -z "$bash_ut_api_test_run_tests_p" ] || return 0

bash_ut_api_test_run_tests_p=t

##

source bash_ut_api_internal_test_util.functions.sh

source bash_ut_api_test_run.functions.sh

##

function q() { # ...

	printf %q "$@"
}

##

nesting_level_of_set_up_tear_down_test=0

declare -A call_count_of_functions_in_scope

function set_up_test_scope() {

	(( call_count_of_functions_in_scope[${FUNCNAME:?}] += 1 ))

	assert "[[ \${call_count_of_functions_in_scope[set_up_test_scope]:-0} -eq 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[tear_down_test_scope]:-0} -eq 0 ]]"

	##

	assert "[[ \${call_count_of_functions_in_scope[set_up_test]:-0} -eq \
	           \${call_count_of_functions_in_scope[tear_down_test]:-0} ]]"

	assert "[[ \${call_count_of_functions_in_scope[set_up_test]:-0} -eq 0 ]]"
}

function tear_down_test_scope() {

	(( call_count_of_functions_in_scope[${FUNCNAME:?}] += 1 ))

	assert "[[ \${call_count_of_functions_in_scope[set_up_test_scope]:-0} -eq 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[tear_down_test_scope]:-0} -eq 1 ]]"

	##

	assert "[[ \${call_count_of_functions_in_scope[set_up_test]:-0} -eq \
	           \${call_count_of_functions_in_scope[tear_down_test]:-0} ]]"

	assert "[[ \${call_count_of_functions_in_scope[set_up_test]:-0} -ge 0 ]]"
}

function set_up_test() {

	(( nesting_level_of_set_up_tear_down_test += 1 ))

	(( call_count_of_functions_in_scope[${FUNCNAME:?}] += 1 ))

	(( call_count_of_functions_in_scope[${this_test_name:?}] += 1 ))

	##

	assert "[[ \${this_test_name:?} != ${FUNCNAME:?} ]]"

	assert "[[ \${nesting_level_of_set_up_tear_down_test:?} -eq 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[${FUNCNAME:?}]:-0} -ge 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[\${this_test_name:?}]:-0} -eq 1 ]]"
}

function tear_down_test() {

	(( nesting_level_of_set_up_tear_down_test -= 1 ))

	(( call_count_of_functions_in_scope[${FUNCNAME:?}] += 1 ))

	##

	assert "[[ \${this_test_name:?} != ${FUNCNAME:?} ]]"

	assert "[[ \${nesting_level_of_set_up_tear_down_test:?} -eq 0 ]]"

	assert "[[ \${call_count_of_functions_in_scope[${FUNCNAME:?}]:-0} -ge 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[\${this_test_name:?}]:-0} -eq 1 ]]"
}

##

function test_conditions_within_test_scope__0000_at_first_test() {

	assert "[[ \${call_count_of_functions_in_scope[set_up_test_scope]:-0} -eq 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[\${this_test_name:?}]:-0} -eq 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[tear_down_test_scope]:-0} -eq 0 ]]"
}

function test_conditions_within_test_scope__zzzz_at_last_test() {

	assert "[[ \${call_count_of_functions_in_scope[set_up_test_scope]:-0} -eq 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[\${this_test_name:?}]:-0} -eq 1 ]]"

	assert "[[ \${call_count_of_functions_in_scope[tear_down_test_scope]:-0} -eq 0 ]]"
}

##

function test_list_all_tests_in_scope__contains_this_test() {

	local result_from_list_all_tests_in_scope=( $(list_all_tests_in_scope) )

	[[ ": ${result_from_list_all_tests_in_scope[*]} :" == *" ${FUNCNAME:?} "* ]]
}

function test_run_test__PATH_contains_directory_of_this_test_script() {

	local d1=$(dirname "$(realpath "${this_test_script_fpn:?}")")

	[[ ::${PATH}:: == *:"${d1:?}":* ]] ||

	fire_test_run_event failed not_in_PATH: [ "${d1:?}" ] PATH: [ "${PATH}" ]
}

function test_run_test__all_vars_set_by_outer_scopes_of_the_test_are_useful_to_the_test_itself() {

	local vars_not_useful=($(

		list_all_unexpected_non_test_vars_defined_in_this_scope |

		egrep -v '^(call_count_of_functions_in_scope|nesting_level_of_set_up_tear_down_test)$' ; # defined by this test scope
	))

	[[ ${#vars_not_useful} -eq 0 ]] ||

	fire_test_run_event failed vars_not_useful: [ "${vars_not_useful[@]}" ]
}

function test_run_test__functions_defined_by_bash_ut_api_test_run_are_available_to_the_test() {

	local function_names=( $(declare -F | perl -pe 's#^declare\s+-f\s+##') )

	[[ ": ${function_names[*]} :" == *" fire_test_run_event "* ]] 

	[[ ": ${function_names[*]} :" == *" run_tests_in_scope "* ]] 

	[[ ": ${function_names[*]} :" == *" run_tests "* ]] 

	[[ ": ${function_names[*]} :" == *" assert "* ]] 
}

function test_run_test__this_test_name_matches_FUNCNAME() {

	[[ "${this_test_name}" == "${FUNCNAME:?}" ]]
}

function test_run_test__this_test_script_fpn_matches_BASH_SOURCE() {

	[[ "${this_test_script_fpn:?}" == "${BASH_SOURCE:?}" ]]
}
