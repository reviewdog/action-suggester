#!/bin/bash

CURRENT=$(cd "$(dirname "$0")" && pwd)

set -eu

# cleanup temporary directory
unset tmpdir
atexit() {
  [[ -n ${tmpdir-} ]] && rm -f "$tmpdir"
}
trap atexit EXIT
trap 'rc=$?; trap - EXIT; atexit; exit $?' INT PIPE TERM

tmpdir=$(mktemp -d)

# sync install.sh with https://github.com/reviewdog/action-setup
curl -sSL https://raw.githubusercontent.com/reviewdog/action-setup/master/install.sh -o "$tmpdir/install.sh"
install -m 755 "$tmpdir/install.sh" "$CURRENT/../install.sh"
