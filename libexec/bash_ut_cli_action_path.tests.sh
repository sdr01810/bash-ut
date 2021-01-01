#!/bin/bash sourced
## Provides tests for bash_ut_cli_action_path() and friends.
## 

[ -z "$bash_ut_cli_action_path_tests_p" ] || return 0

bash_ut_cli_action_path_tests_p=t

##

source bash_ut_cli_action_path.functions.sh

##

function test_bash_ut_cli_action_path__arg_count_0() {

	local result_actual=$(bash_ut_cli_action_path 2>&1)

	local result_expected=$(dirname "$(dirname "$(realpath "${BASH_SOURCE:?}")")")/bin

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ ${result_actual} ] expected: [ ${result_expected} ]
}

function test_bash_ut_cli_action_path__arg_count_1__exists_y() {

	local result_actual=$(bash_ut_cli_action_path functions.sh 2>&1)

	local result_expected=${this_script_pkg_root:?}/functions.sh

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ ${result_actual} ] expected: [ ${result_expected} ]
}

function test_bash_ut_cli_action_path__arg_count_1__exists_n() {

	local result_actual=$(bash_ut_cli_action_path MISSING 2>&1)

	local result_expected=${this_script_pkg_root:?}/MISSING

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ ${result_actual} ] expected: [ ${result_expected} ]
}

function test_bash_ut_cli_action_path__arg_count_2() {

	local result_actual=$(bash_ut_cli_action_path bin libexec 2>&1)

	local result_expected=${this_script_pkg_root:?}/bin:${this_script_pkg_root:?}/libexec

	[[ "${result_actual}" == "${result_expected}" ]] ||

	fire_test_run_event failed actual: [ ${result_actual} ] expected: [ ${result_expected} ]
}

