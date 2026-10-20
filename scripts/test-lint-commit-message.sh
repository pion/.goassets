#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

# This is a test for lint_commit_message.go script
# This script is not intended for linting commit messages

function on_exit {
  rm TEST_COMMIT_MSG
}
trap on_exit EXIT

RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

function print_pass {
  echo -e "${GREEN_COLOR}PASS${NO_COLOR}"
}

function print_fail {
  echo -e "${RED_COLOR}FAIL${NO_COLOR}"
}

# Test good commit messages

GOOD_COMMIT_MSG="Subject line

Body"

LONG_SUBJECT_EXCEPTION_FOR_MODULE_UPDATE="Update module github.com/pion/averylongmodulenameforthelengthexception to v0.1.12

Body"
EMPTY_BODY="Subject"

LINE_WITH_72_CHARACTERS=$(printf 'A%.0s' {1..72})
SUBJECT_AND_BODY_AT_LIMIT="$LINE_WITH_72_CHARACTERS

$LINE_WITH_72_CHARACTERS"

GOOD_COMMITS_MESSAGES=(
  "$GOOD_COMMIT_MSG"
  "$LONG_SUBJECT_EXCEPTION_FOR_MODULE_UPDATE"
  "$EMPTY_BODY"
  "$SUBJECT_AND_BODY_AT_LIMIT"
)

for i in "${!GOOD_COMMITS_MESSAGES[@]}"; do
  TEST_COMMIT_MSG=${GOOD_COMMITS_MESSAGES[$i]}

  echo -n "$TEST_COMMIT_MSG" >TEST_COMMIT_MSG
  go run ./lint_commit_message.go TEST_COMMIT_MSG >/dev/null

  if [[ $? -ne 0 ]]; then
    print_fail
    exit 1
  fi
done

# Test bad commit messages

NO_EMPTY_LINE_BETWEEN_SUBJECT_AND_BODY="Subject
Body"

SUBJECT_STARTS_WITH_LOWER_CASE="subject"

SUBJECT_ENDS_WITH_PERIOD="Subject."

SUBJECT_WITH_73_CHARACTERS="${LINE_WITH_72_CHARACTERS}A"

BODY_WITH_73_CHARACTERS="Subject

${LINE_WITH_72_CHARACTERS}A"

BAD_COMMITS_MESSAGES=(
  "$NO_EMPTY_LINE_BETWEEN_SUBJECT_AND_BODY"
  "$SUBJECT_STARTS_WITH_LOWER_CASE"
  "$SUBJECT_ENDS_WITH_PERIOD"
  "$SUBJECT_WITH_73_CHARACTERS"
  "$BODY_WITH_73_CHARACTERS"
)

for i in "${!BAD_COMMITS_MESSAGES[@]}"; do
  TEST_COMMIT_MSG=${BAD_COMMITS_MESSAGES[$i]}

  echo -n "$TEST_COMMIT_MSG" >TEST_COMMIT_MSG
  go run ./lint_commit_message.go TEST_COMMIT_MSG >/dev/null

  if [[ $? -ne 1 ]]; then
    print_fail
    exit 1
  fi
done

print_pass
