#!/bin/sh

if ! command -v reviewdog >/dev/null 2>&1; then
  echo "reviewdog was not installed"
  exit 1
fi
echo "::group::📖 reviewdog -h"
reviewdog -h 2>&1 || true
echo "::endgroup::"
