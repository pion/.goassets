#!/bin/sh
# SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

# Redirect output to stderr.
exec 1>&2

.github/.goassets/scripts/lint-disallowed-functions-in-library.sh
.github/.goassets/scripts/lint-no-trailing-newline-in-log-messages.sh
