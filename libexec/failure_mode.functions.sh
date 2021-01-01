#!/bin/bash sourced
## Provides utility functions to help with failure modes.
## 

[ -z "$failure_mode_functions_p" ] || return 0

failure_mode_functions_p=t

failure_mode_debug_p=

##

source croak.functions.sh

