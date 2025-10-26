#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

set -e

go run .github/.goassets/scripts/lint_commit_message.go $1
