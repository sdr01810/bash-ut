#!/bin/bash sourced
## Provides the bash-ut API runtime.
## 

[ -z "$bash_ut_api_functions_p" ] || return 0

bash_ut_api_functions_p=t

bash_ut_api_debug_p=

##

# if the directory of this script is not in PATH...

for _1_ in "$(dirname "$(realpath "${BASH_SOURCE:?}")")" ; do

	if [[ ::"${PATH}":: != *:"${_1_:?}":* ]] ; then

		PATH=${_1_:?}${PATH:+:}${PATH} # put it there
	fi
done

##

source bash_ut_api_assertion.functions.sh

source bash_ut_api_test_result_formatter.functions.sh

source bash_ut_api_test_run.functions.sh

source bash_ut_api_value_predicate.functions.sh

##
