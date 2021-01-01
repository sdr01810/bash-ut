#!/bin/bash sourced
## Provides tests for bash_ut_api_internal_test_util functions.
## 

[ -z "$bash_ut_api_internal_test_util_functions_p" ] || return 0

bash_ut_api_internal_test_util_functions_p=t

bash_ut_api_internal_test_util_debug_p=

##

function list_all_unexpected_non_test_vars_defined_in_this_scope() {

	(set -o posix ; set) | egrep '^\w+=' | 

	sed -e 's/=.*//' | # strip off values

	egrep -v '^_[0-9]_$' | # omit scratch variables

	egrep -v '^[_0-9A-Z]+$' | # omit environment variables

	egrep -v '(^bash_ut_|^this_(script|test)_)' | # considered useful

	egrep -v '(_(debug|functions|mocks|tests)_p$)' ; # considered useful
}
