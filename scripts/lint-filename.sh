#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

set -e

SCRIPT_PATH=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
GO_REGEX="^[a-zA-Z][a-zA-Z0-9_]*\.go$"

find "${SCRIPT_PATH}/.." -name "*.go" | while read FULLPATH; do
  FILENAME=$(basename -- "${FULLPATH}")

  if ! [[ ${FILENAME} =~ ${GO_REGEX} ]]; then
    echo "${FILENAME} is not a valid filename for Go code, only alpha, numbers and underscores are supported"
    exit 1
  fi
done
