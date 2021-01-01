#!/bin/bash sourced
## Provides tests for bash_ut_cli_action_run() and friends.
## 

[ -z "$bash_ut_cli_action_run_tests_p" ] || return 0

bash_ut_cli_action_run_tests_p=t

##

source bash_ut_cli_action_run.functions.sh

##

bash_ut_always_failing_tests_fpn=${this_script_pkg_root:?}/share/samples/tests/always_failing.tests.sh

bash_ut_always_missing_tests_fpn=${this_script_pkg_root:?}/share/samples/tests/always_missing.tests.sh

bash_ut_always_passing_tests_fpn=${this_script_pkg_root:?}/share/samples/tests/always_passing.tests.sh

##

function test_bash_ut_cli_action_run__arg_count_0() {

	local result_actual=$("${this_script_fpn:?}" run 2>&1)

	local result_expected=""

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ ${result_actual} ] expected: [ ${result_expected} ]
}

function test_bash_ut_cli_action_run__arg_count_1__exists_y() {(

	local result_actual= result_expected=

	cd "${this_script_pkg_root:?}" || return $?

	local test_script_01_fpn=${bash_ut_always_passing_tests_fpn:?}
	local test_script_01_run_output_fpn=${test_script_01_fpn%.sh}.run.stdout+stderr

	result_actual=${result_actual}$(CROAK_LOD=0 "${this_script_fpn:?}" run "${test_script_01_fpn:?}" 2>&1)

	result_expected=${result_expected}$(cat "${test_script_01_run_output_fpn:?}")

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ "${result_actual}" ] expected: [ "${result_expected}" ]
)}

function test_bash_ut_cli_action_run__arg_count_1__exists_n() {(

	local result_actual= result_expected=

	cd "${this_script_pkg_root:?}" || return $?

	local test_script_01_fpn=${bash_ut_always_missing_tests_fpn:?}
	local test_script_01_run_output_fpn=${test_script_01_fpn%.sh}.run.stdout+stderr

	result_actual=${result_actual}$(CROAK_LOD=0 "${this_script_fpn:?}" run "${test_script_01_fpn:?}" 2>&1)

	result_expected=${result_expected}$(cat "${test_script_01_run_output_fpn:?}" | egrep -v '^\^--')

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ "${result_actual}" ] expected: [ "${result_expected}" ]
)}

function test_bash_ut_cli_action_run__arg_count_2() {(

	local result_actual= result_expected=

	cd "${this_script_pkg_root:?}" || return $?

	local test_script_01_fpn=${bash_ut_always_passing_tests_fpn:?}
	local test_script_01_run_output_fpn=${test_script_01_fpn%.sh}.run.stdout+stderr

	local test_script_02_fpn=${bash_ut_always_failing_tests_fpn:?}
	local test_script_02_run_output_fpn=${test_script_02_fpn%.sh}.run.stdout+stderr

	result_actual=${result_actual}$("${this_script_fpn:?}" run "${test_script_01_fpn:?}" 2>&1)
	result_actual=${result_actual}$(echo)
	result_actual=${result_actual}$("${this_script_fpn:?}" run "${test_script_02_fpn:?}" 2>&1)

	result_expected=${result_expected}$(cat "${test_script_01_run_output_fpn:?}")
	result_expected=${result_expected}$(echo)
	result_expected=${result_expected}$(cat "${test_script_02_run_output_fpn:?}")

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ "${result_actual}" ] expected: [ "${result_expected}" ]
)}

