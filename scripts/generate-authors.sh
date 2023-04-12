#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

set -e

SCRIPT_PATH=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
if [ -z "${AUTHORS_PATH}" ]; then
  AUTHORS_PATH="$(git rev-parse --show-toplevel)/AUTHORS.txt"
fi

if [ -f ${SCRIPT_PATH}/.ci.conf ]; then
  . ${SCRIPT_PATH}/.ci.conf
fi

# If you want to exclude a name from all repositories, send a PR to
# https://github.com/pion/.goassets.
# If you want to exclude a name only from this repository,
# add EXCLUDED_CONTRIBUTORS=('name') to .github/.ci.conf
EXCLUDED_CONTRIBUTORS+=('John R. Bradley' 'renovate[bot]' 'Renovate Bot' 'Pion Bot' 'pionbot')

EXTRA_CONTRIBUTORS="$(
  (
    sed -n '/^# List of contributors not appearing in Git history/{n; :l; /.\+/p; n; b l}' ${AUTHORS_PATH} 2>/dev/null \
      || true
  ) | sort | uniq
)"

CONTRIBUTORS=()

shouldBeIncluded() {
  for i in "${EXCLUDED_CONTRIBUTORS[@]}"; do
    if [[ $1 =~ "$i" ]]; then
      return 1
    fi
  done
  return 0
}

IFS=$'\n' #Only split on newline
for CONTRIBUTOR in $(
  (
    git log --format='%aN <%aE>'
    git log --format='%(trailers:key=Co-authored-by)' | sed -n 's/^[^:]*:\s*//p'
  ) | LC_ALL=C.UTF-8 sort -uf
); do
  if shouldBeIncluded ${CONTRIBUTOR}; then
    CONTRIBUTORS+=("${CONTRIBUTOR}")
  fi
done
unset IFS

if [ ${#CONTRIBUTORS[@]} -ne 0 ] || [ -n ${EXTRA_CONTRIBUTORS} ]; then
  cat <<EOH >${AUTHORS_PATH}
# Thank you to everyone that made Pion possible. If you are interested in contributing
# we would love to have you https://github.com/pion/webrtc/wiki/Contributing
#
# This file is auto generated, using git to list all individuals contributors.
# see https://github.com/pion/.goassets/blob/master/scripts/generate-authors.sh for the scripting
EOH
  for i in "${CONTRIBUTORS[@]}"; do
    echo "$i" >>${AUTHORS_PATH}
  done
  cat <<EOH >>${AUTHORS_PATH}

# List of contributors not appearing in Git history
${EXTRA_CONTRIBUTORS}
EOH
  exit 0
fi
