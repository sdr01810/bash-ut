#!/bin/bash sourced
## Provides function bash_ut_cli_action_run() and friends.
## 

[ -z "$bash_ut_cli_action_run_functions_p" ] || return 0

bash_ut_cli_action_run_functions_p=t

bash_ut_cli_action_run_debug_p=

##

source bash_ut_api_test_run.functions.sh

##

function bash_ut_cli_action_run() { # [ test_script_pn ... ]

	run_tests_in_each_file "$@"
}
