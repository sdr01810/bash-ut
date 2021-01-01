#!/bin/bash sourced
## Provides tests for bash_ut_api_assertion functions.
## 

[ -z "$bash_ut_api_assertion_tests_p" ] || return 0

bash_ut_api_assertion_tests_p=t

##

source bash_ut_api_test_run.functions.sh

##

function test_assert__arg_count_0() {

	local result_actual= rc_actual=0
	result_actual=$(assert 2>&1) || rc_actual=$?

	local result_expected=""

	[[ ${result_actual} == "${result_expected}" ]] ||
	fire_test_run_event assertion_failed result_actual: "${result_actual}"

	[[ ${rc_actual} -eq 0 ]] ||
	fire_test_run_event assertion_failed result_actual: "${rc_actual}"
}

function test_assert__arg_count_1__valid_n() {

	local result_actual= rc_actual=0
	result_actual=$(assert MISSING 2>&1) || rc_actual=$?

	result_actual="${result_actual%not found?*}not found"

	local result_expected_head="$(realpath "${BASH_SOURCE/.tests./.functions.}"): line "
	local result_expected_tail=": MISSING: command not found"

	[[ ${result_actual} == "${result_expected_head}"*"${result_expected_tail}" ]] ||
	fire_test_run_event assertion_failed result_actual: "${result_actual}"

	[[ ${rc_actual} -eq 0 ]] ||
	fire_test_run_event assertion_failed rc_actual: "${rc_actual:?}"
}

function test_assert__arg_count_1__valid_y__predicate_false() {

	local result_actual= rc_actual=0
	result_actual=$(assert false 2>&1) || rc_actual=$?

	local result_expected=">>> test name: ${FUNCNAME:?} event: assertion_failed predicate: false"

	[[ ${result_actual} == "${result_expected}" ]] ||
	fire_test_run_event assertion_failed result_actual: "${result_actual}"

	[[ ${rc_actual} -eq 0 ]] ||
	fire_test_run_event assertion_failed rc_actual: "${rc_actual:?}"
}

function test_assert__arg_count_1__valid_y__predicate_true() {

	local result_actual= rc_actual=0
	result_actual=$(assert true 2>&1) || rc_actual=$?

	local result_expected=""

	[[ ${result_actual} == "${result_expected}" ]] ||
	fire_test_run_event assertion_failed result_actual: "${result_actual}"

	[[ ${rc_actual} -eq 0 ]] ||
	fire_test_run_event assertion_failed rc_actual: "${rc_actual:?}"
}

function test_assert__arg_count_N__valid_n() {

	local result_actual= rc_actual=0
	result_actual=$(assert [ 1 -eq X ] 2>&1) || rc_actual=$?

	result_actual=${result_actual%expected?*}expected

	local result_expected_head="$(realpath "${BASH_SOURCE/.tests./.functions.}"): line "
	local result_expected_tail=": [: X: integer expression expected"

	[[ ${result_actual} == "${result_expected_head}"*"${result_expected_tail}" ]] ||
	fire_test_run_event assertion_failed result_actual: "${result_actual}"

	[[ ${rc_actual} -eq 0 ]] ||
	fire_test_run_event assertion_failed rc_actual: "${rc_actual:?}"
}

function test_assert__arg_count_N__valid_y__predicate_false() {

	local result_actual= rc_actual=0
	result_actual=$(assert [ 1 -ne 1 ] 2>&1) || rc_actual=$?

	local result_expected=">>> test name: ${FUNCNAME:?} event: assertion_failed predicate: [ 1 -ne 1 ]"

	[[ ${result_actual} == "${result_expected}" ]] ||
	fire_test_run_event assertion_failed result_actual: {[ "${result_actual}" ]} result_expected: {[ "${result_expected}" ]}

	[[ ${rc_actual} -eq 0 ]] ||
	fire_test_run_event assertion_failed rc_actual: "${rc_actual:?}"
}

function test_assert__arg_count_N__valid_y__predicate_true() {

	local result_actual= rc_actual=0
	result_actual=$(assert [ 1 -eq 1 ] 2>&1) || rc_actual=$?

	local result_expected=""

	[[ ${result_actual} == "${result_expected}" ]] ||
	fire_test_run_event assertion_failed result_actual: "${result_actual}"

	[[ ${rc_actual} -eq 0 ]] ||
	fire_test_run_event assertion_failed rc_actual: "${rc_actual:?}"
}

