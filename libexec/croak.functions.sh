#!/bin/bash sourced
## Provides utility functions to help with failure modes.
## 

[ -z "$croak_functions_p" ] || return 0

croak_functions_p=t

croak_debug_p=

##

function croak() { # [ message ... ]

	local message=${*} ; shift ${#}

	[ -n "${message}" ] || message="internal error"

	echo 1>&2 "${this_script_name:?}: ${message:?}"

	if [ "${CROAK_LOD:-1}" -gt 0 ] ; then

		local i=0

		while [ $i -lt ${#FUNCNAME[@]} ] ; do

			if [[ ! "${FUNCNAME[$i]:?}" =~ ^croak($|_) ]] ; then

				echo 1>&2 "^-- "
				echo 1>&2 "^-- in function: ${FUNCNAME[$i]:?};"
				echo 1>&2 "^-- at line ${BASH_LINENO[$i]:?} of file: ${BASH_SOURCE[$i]:?}"
				break
			fi

			(( i += 1 ))
		done
	fi

	return 2
}

function croak_cannot_happen() { # [ message ... ]

	croak "cannot happen${*:+: }${*}"
}

function croak_internal_error() { # [ message ... ]

	croak "internal error${*:+: }${*}"
}

function croak_invalid_argument() { # [ message ... ]

	"${FUNCNAME:?}s" "$@"
}

function croak_invalid_arguments() { # [ message ... ]

	croak "invalid argument(s)${*:+: }${*}"
}

function croak_option_already_specified() { # [ message ... ]

	croak "option already specified${*:+: }${*}"
}


function croak_unexpected_argument() { # [ message ... ]

	"${FUNCNAME:?}s" "$@"
}

function croak_unexpected_arguments() { # [ message ... ]

	croak "unexpected argument(s)${*:+: }${*}"
}

function croak_unsupported_argument() { # [ message ... ]

	"${FUNCNAME:?}s" "$@"
}

function croak_unsupported_arguments() { # [ message ... ]

	croak "unsupported argument(s)${*:+: }${*}"
}

function croak_unexpected_option() { # [ message ... ]

	croak "unexpected option${*:+: }${*}"
}

function croak_unsupported_option() { # [ message ... ]

	croak "unsupported option${*:+: }${*}"
}

