#!/bin/bash
# SPDX-FileCopyrightText: 2026 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

# Updates the go directive in go.mod to the expected version

set -e

. "${ASSETS_DIR}/scripts/go-mod-version.sh"

sed -i -E "s/^go[[:space:]]+[[:digit:].]+$/go ${GO_MOD_VERSION_EXPECTED}/" go.mod
