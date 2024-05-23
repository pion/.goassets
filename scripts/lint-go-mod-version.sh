#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

set -e

SCRIPT_PATH=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)

if [ -f ${SCRIPT_PATH}/../../.ci.conf ]; then
  . ${SCRIPT_PATH}/../../.ci.conf
fi

if [ -z "${GO_MOD_VERSION_EXPECTED}" ]; then
  GO_MOD_VERSION_EXPECTED="1.19" # auto-update/prev-go-version
fi

GO_MOD_FILE=go.mod
GO_MOD_VERSION=$(sed -En 's/^go[[:space:]]+([[:digit:].]+)$/\1/p' ${GO_MOD_FILE})

if [[ ${GO_MOD_VERSION} != ${GO_MOD_VERSION_EXPECTED} ]]; then
  if [[ -n "${CI}" ]]; then
    GO_MOD_VERSION_LINE=$(sed -n '/^go/=' go.mod)
    echo "::error title=Invalid Go version,file=${GO_MOD_FILE},line=${GO_MOD_VERSION_LINE},::Found ${GO_MOD_VERSION}. Expected ${GO_MOD_VERSION_EXPECTED}"
  else
    echo "Invalid Go version in go.mod:"
    echo "  Found    ${GO_MOD_VERSION}"
    echo "  Expected ${GO_MOD_VERSION_EXPECTED}"
  fi
  exit 1
fi
