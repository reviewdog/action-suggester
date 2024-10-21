#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

if [ "${INPUT_FAIL_ON_ERROR}" = "true" ]; then
  echo "::warning title=fail-on-error-is-deprecated::reviewdog: -fail-on-error is deprecated"
  INPUT_REVIEWDOG_FLAGS="${INPUT_REVIEWDOG_FLAGS} -fail-level=error "
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

TMPFILE=$(mktemp)
git diff >"${TMPFILE}"

git stash -u

# shellcheck disable=SC2086
reviewdog \
  -name="${INPUT_TOOL_NAME:-reviewdog-suggester}" \
  -f=diff \
  -f.diff.strip=1 \
  -reporter="github-pr-review" \
  -filter-mode="${INPUT_FILTER_MODE}" \
  -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
  -level="${INPUT_LEVEL}" \
  ${INPUT_REVIEWDOG_FLAGS} <"${TMPFILE}" # INPUT_REVIEWDOG_FLAGS is intentionally split to pass multiple flags

EXIT_CODE=$?

if [ "${INPUT_CLEANUP}" = "true" ]; then
  git stash drop || true
else
  git stash pop || true
fi

exit "${EXIT_CODE}"
