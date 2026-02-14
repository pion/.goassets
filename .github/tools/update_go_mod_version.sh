#!/bin/bash
# SPDX-FileCopyrightText: 2026 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

# Updates the go directive in go.mod to the expected version

set -e

. "${ASSETS_DIR}/scripts/go-mod-version.sh"

# Extract the current version from go.mod and compare major.minor only,
# so that mismatches between semver and non-semver forms (e.g. 1.24 vs 1.24.0)
# don't cause unnecessary rewrites.
GO_MOD_VERSION_CURRENT=$(sed -En 's/^go[[:space:]]+([[:digit:].]+)$/\1/p' go.mod)
CURRENT_MAJOR_MINOR=$(echo "${GO_MOD_VERSION_CURRENT}" | sed -E 's/^([0-9]+\.[0-9]+).*/\1/')
EXPECTED_MAJOR_MINOR=$(echo "${GO_MOD_VERSION_EXPECTED}" | sed -E 's/^([0-9]+\.[0-9]+).*/\1/')

if [[ "${CURRENT_MAJOR_MINOR}" != "${EXPECTED_MAJOR_MINOR}" ]]; then
  sed -i -E "s/^go[[:space:]]+[[:digit:].]+$/go ${GO_MOD_VERSION_EXPECTED}/" go.mod
fi
