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

INSTALL_SCRIPT='https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh'
if [ "${VERSION}" = 'nightly' ]; then
  INSTALL_SCRIPT='https://raw.githubusercontent.com/reviewdog/nightly/30fccfe9f47f7e6fd8b3c38aa0da11a6c9f04de7/install.sh'
  VERSION='latest'
fi

mkdir -p "${TEMP}/reviewdog/bin"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
(
  if command -v curl 2>&1 >/dev/null; then
    curl -sfL "${INSTALL_SCRIPT}"
  elif command -v wget 2>&1 >/dev/null; then
    wget -O - "${INSTALL_SCRIPT}"
  else
    echo "curl or wget is required" >&2
    exit 1
  fi
) | sh -s -- -b "${TEMP}/reviewdog/bin" "${VERSION}" 2>&1
echo '::endgroup::'

echo "${TEMP}/reviewdog/bin" >>"${GITHUB_PATH}"
