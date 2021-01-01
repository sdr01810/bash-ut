#!/bin/bash sourced
## Provides tests for bash_ut_cli_dispatcher() and friends.
## 

[ -z "$bash_ut_cli_dispatcher_tests_p" ] || return 0

bash_ut_cli_dispatcher_tests_p=t

##

source bash_ut_cli_dispatcher.functions.sh

##

bash_ut_always_failing_tests_fpn=${this_script_pkg_root:?}/share/samples/tests/always_failing.tests.sh

bash_ut_always_missing_tests_fpn=${this_script_pkg_root:?}/share/samples/tests/always_missing.tests.sh

bash_ut_always_passing_tests_fpn=${this_script_pkg_root:?}/share/samples/tests/always_passing.tests.sh

##

function test_bash_ut_cli_dispatcher__arg_count_0() {

	local result_actual=$(bash_ut_cli_dispatcher 2>&1)

	local result_expected=""

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ "${result_actual}" ] expected: [ "${result_expected}" ]
}

function test_bash_ut_cli_dispatcher__arg_count_1__valid_action_y() {

	local result_actual=$(bash_ut_cli_dispatcher eval : 2>&1)

	local result_expected=""

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ "${result_actual}" ] expected: [ "${result_expected}" ]
}

function test_bash_ut_cli_dispatcher__arg_count_1__valid_action_n__empty() {

	local result_actual=$(bash_ut_cli_dispatcher "" 2>&1)

	local result_expected="bash_ut_cli_dispatcher: unrecognized/unsupported action: ''"

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ "${result_actual}" ] expected: [ "${result_expected}" ]
}

function test_bash_ut_cli_dispatcher__arg_count_1__valid_action_n__unrecognized() {

	local result_actual=$(bash_ut_cli_dispatcher FOO 2>&1)

	local result_expected="bash_ut_cli_dispatcher: unrecognized/unsupported action: FOO"

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ "${result_actual}" ] expected: [ "${result_expected}" ]
}

