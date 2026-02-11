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
  GO_MOD_VERSION_EXPECTED="1.24" # auto-update/prev-go-version
fi

GO_MOD_FILE=go.mod
GO_MOD_VERSION=$(sed -En 's/^go[[:space:]]+([[:digit:].]+)$/\1/p' ${GO_MOD_FILE})

# Extract major.minor version from semver
GO_MOD_VERSION_MAJOR_MINOR=$(echo ${GO_MOD_VERSION} | sed -E 's/^([0-9]+\.[0-9]+).*/\1/')
GO_MOD_VERSION_EXPECTED_MAJOR_MINOR=$(echo ${GO_MOD_VERSION_EXPECTED} | sed -E 's/^([0-9]+\.[0-9]+).*/\1/')

if [[ ${GO_MOD_VERSION_MAJOR_MINOR} != ${GO_MOD_VERSION_EXPECTED_MAJOR_MINOR} ]]; then
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
