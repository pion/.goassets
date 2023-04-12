#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

set -e

display_commit_message_error() {
  if [ -n "${CI}" ]; then
    echo "::error title=Commit message check failed::$2"
    echo -e "::group::Commit message\n$1\n::endgroup::"
  else
    cat <<EndOfMessage
$1

-------------------------------------------------
EndOfMessage
  fi

  cat <<EndOfMessage
The preceding commit message is invalid
it failed '$2' of the following checks

* Separate subject from body with a blank line
* Limit the subject line to 50 characters
* Capitalize the subject line
* Do not end the subject line with a period
* Wrap the body at 72 characters
EndOfMessage

  exit 1
}

lint_commit_message() {
  SECOND_LINE=$(echo "$1" | awk 'NR == 2')

  if [[ -n $SECOND_LINE ]]; then
    display_commit_message_error "$1" 'Separate subject from body with a blank line'
  fi

  if [[ "$(echo "$1" | head -n1 | awk '{print length}')" -gt 50 ]]; then
    re='^Update module [0-9a-zA-Z./]+ to v[0-9]+\.[0-9]+\.[0-9]+( \[.*\])?$'
    if [[ "$(echo "$1" | head -n1)" =~ $re ]]; then
      echo "Ignored subject line length error for module update commit"
    else
      display_commit_message_error "$1" 'Limit the subject line to 50 characters'
    fi
  fi

  if [[ ! $1 =~ ^[A-Z] ]]; then
    display_commit_message_error "$1" 'Capitalize the subject line'
  fi

  if [[ "$(echo "$1" | awk 'NR == 1 {print substr($0,length($0),1)}')" == "." ]]; then
    display_commit_message_error "$1" 'Do not end the subject line with a period'
  fi

  if [[ "$(echo "$1" | awk '{print length}' | sort -nr | head -1)" -gt 72 ]]; then
    display_commit_message_error "$1" 'Wrap the body at 72 characters'
  fi
}

if [ "$#" -eq 1 ]; then
  if [ ! -f "$1" ]; then
    echo "$0 was passed one argument, but was not a valid file"
    exit 1
  fi
  lint_commit_message "$(sed -n '/# Please enter the commit message for your changes. Lines starting/q;p' "$1")"
else
  for COMMIT in $(git rev-list --no-merges origin/master..); do
    lint_commit_message "$(git log --format="%B" -n 1 ${COMMIT})"
  done
fi
