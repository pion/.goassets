#!/bin/sh

# Redirect output to stderr.
exec 1>&2

.github/.goassets/scripts/lint-disallowed-functions-in-library.sh
.github/.goassets/scripts/lint-no-trailing-newline-in-log-messages.sh
