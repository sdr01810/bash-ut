#!/bin/bash sourced
## Sourced at the beginning of all scripts in this installation set.
## 

set -e

set -o pipefail 2>&- || :

##

this_script_fpn=$(realpath "${0:?}")

this_script_dpn=$(dirname "${this_script_fpn:?}")
this_script_fbn=$(basename "${this_script_fpn:?}")

##

this_script_name=${this_script_fbn%.*sh}

this_script_pkg_root=$(dirname "${this_script_dpn:?}")

source "${this_script_pkg_root:?}"/libexec/bash_ut_api.functions.sh

##

source xx.functions.sh

##

