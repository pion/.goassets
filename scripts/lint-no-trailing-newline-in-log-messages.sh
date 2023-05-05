#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

set -e

SCRIPT_PATH=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
if [ -f ${SCRIPT_PATH}/.ci.conf ]; then
  . ${SCRIPT_PATH}/.ci.conf
fi

FILES=$(
  find "${SCRIPT_PATH}/.." -name "*.go" \
    | while read FILE; do
      EXCLUDED=false
      for EXCLUDE_DIRECTORY in ${EXCLUDE_DIRECTORIES}; do
        if [[ $file == */${EXCLUDE_DIRECTORY}/* ]]; then
          EXCLUDED=true
          break
        fi
      done
      ${EXCLUDED} || echo "${FILE}"
    done
)

if grep -E '\.(Trace|Debug|Info|Warn|Error)f?\("[^"]*\\n"\)?' ${FILES} | grep -v -e 'nolint'; then
  echo "Log format strings should have trailing new-line"
  exit 1
fi
