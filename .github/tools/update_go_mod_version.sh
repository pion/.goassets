#!/bin/bash
# SPDX-FileCopyrightText: 2026 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

# Updates the go directive in go.mod to the expected version

set -e

. "${ASSETS_DIR}/scripts/go-mod-version.sh"

# Normalize expected version to semver so both 1.24 and 1.24.0 become 1.24.0.
GO_MOD_VERSION_EXPECTED_SEMVER=$(echo "${GO_MOD_VERSION_EXPECTED}" | sed -E 's/^([0-9]+\.[0-9]+)$/\1.0/')
GO_MOD_VERSION_CURRENT=$(sed -En 's/^go[[:space:]]+([[:digit:].]+)$/\1/p' go.mod)

if [[ "${GO_MOD_VERSION_CURRENT}" != "${GO_MOD_VERSION_EXPECTED_SEMVER}" ]]; then
  sed -i -E "s/^go[[:space:]]+[[:digit:].]+$/go ${GO_MOD_VERSION_EXPECTED_SEMVER}/" go.mod
fi
