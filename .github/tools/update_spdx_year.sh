#!/bin/bash
# SPDX-FileCopyrightText: 2026 The Pion community <https://pion.ly>
# SPDX-License-Identifier: MIT

# Updates copyright year in files matching "YYYY The Pion community <https://pion.ly>"

set -e

current_year=$(date +%Y)

find . -type d \( -name .git -o -name vendor -o -name third_party -o -name node_modules \) -prune -o \
  -type f -print0 | while IFS= read -r -d '' file; do
  if head -c 1024 "$file" 2>/dev/null | grep -q "The Pion community <https://pion.ly>"; then
    if sed -i "s/[0-9]\{4\}\(-[0-9]\{4\}\)\?\( The Pion community <https:\/\/pion\.ly>\)/${current_year}\2/g" "$file" 2>/dev/null; then
      echo "Updated: $file"
    fi
  fi
done
