#!/bin/sh

set -eu

VERSION="${REVIEWDOG_VERSION:-latest}"

TEMP="${REVIEWDOG_TEMPDIR}"
if [ -z "${TEMP}" ]; then
  if [ -n "${RUNNER_TEMP}" ]; then
    TEMP="${RUNNER_TEMP}"
  else
    TEMP="$(mktemp -d)"
  fi
fi

INSTALL_SCRIPT="$GITHUB_ACTION_PATH/install-reviewdog.sh"
if [ "${VERSION}" = 'nightly' ]; then
  INSTALL_SCRIPT="$GITHUB_ACTION_PATH/install-nightly.sh"
  VERSION='latest'
fi

mkdir -p "${TEMP}/reviewdog/bin"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
cat "${INSTALL_SCRIPT}" | sh -s -- -b "${TEMP}/reviewdog/bin" "${VERSION}" 2>&1
echo '::endgroup::'

echo "${TEMP}/reviewdog/bin" >>"${GITHUB_PATH}"
