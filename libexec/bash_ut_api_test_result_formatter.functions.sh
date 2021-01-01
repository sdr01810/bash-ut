#!/bin/bash sourced
## Provides functions pertaining to a test result formatter.
## 
## In addition to utility functions, this module provides these standard
## formatters: raw, and TAP.
##
## See also:
##
##     TAP (test anything protocol)
## 

[ -z "$bash_ut_api_test_result_formatter_functions_p" ] || return 0

bash_ut_api_test_result_formatter_functions_p=t

bash_ut_api_test_result_formatter_debug_p=

##

source failure_mode.functions.sh

##

function bash_ut_api_test_result_formatter__raw() {

	cat
}

function bash_ut_api_test_result_formatter__tap() {

	false # FIXME: implement this stub
}

