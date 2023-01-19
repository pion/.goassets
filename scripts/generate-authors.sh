#!/usr/bin/env bash

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

EXCLUDED_CONTRIBUTORS+=('John R. Bradley' 'renovate[bot]' 'Renovate Bot' 'Pion Bot' 'pionbot')
# If you want to exclude a name from all repositories, send a PR to
# https://github.com/pion/.goassets.
# If you want to exclude a name only from this repository,
# add EXCLUDED_CONTRIBUTORS=('name') to .github/.ci.conf

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

if [ ${#CONTRIBUTORS[@]} -ne 0 ]; then
  cat <<EOH >${AUTHORS_PATH}
# Thank you to everyone that made Pion possible. If you are interested in contributing
# we would love to have you https://github.com/pion/webrtc/wiki/Contributing
#
# This file is auto generated, using git to list all individuals contributors.
# see $(.github/generate-authors.sh) for the scripting
EOH
  for i in "${CONTRIBUTORS[@]}"; do
    echo "$i" >>${AUTHORS_PATH}
  done
  exit 0
fi
