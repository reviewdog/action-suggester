# action-suggester

[![Test](https://github.com/reviewdog/action-suggester/workflows/Test/badge.svg)](https://github.com/reviewdog/action-suggester/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/reviewdog/action-suggester/workflows/reviewdog/badge.svg)](https://github.com/reviewdog/action-suggester/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/reviewdog/action-suggester/workflows/depup/badge.svg)](https://github.com/reviewdog/action-suggester/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-suggester/workflows/release/badge.svg)](https://github.com/reviewdog/action-suggester/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-suggester?logo=github&sort=semver)](https://github.com/reviewdog/action-suggester/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)
[![Used-by counter](https://img.shields.io/endpoint?url=https://haya14busa.github.io/github-used-by/data/reviewdog/action-suggester/shieldsio.json)](https://github.com/haya14busa/github-used-by/tree/main/repo/reviewdog/action-suggester)

![shfmt demo](https://user-images.githubusercontent.com/3797062/89161351-75c31880-d5ad-11ea-8e05-b73b00a7783e.png)
![shellcheck demo](https://user-images.githubusercontent.com/3797062/89164248-cfc5dd00-d5b1-11ea-9983-188f56de7eba.png)
![gofmt demo](https://user-images.githubusercontent.com/3797062/89164333-ea985180-d5b1-11ea-9452-1240c2dc82f7.png)
![multiline demo](https://user-images.githubusercontent.com/3797062/89168305-a3ad5a80-d5b7-11ea-8939-be7ac1976d30.png)

action-suggester is a handy action which suggests any code changes based on
diff through GitHub Multi-line code suggestions by using [reviewdog](https://github.com/reviewdog/reviewdog).

You can use any formatters or linters with auto-fix feature for any languages
and the reviewdog suggester support any changes including inline change,
multi-line changes, insertion, and deletion.

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  ### Flags for reviewdog ###
  tool_name:
    description: 'Tool name to use for reviewdog reporter'
    default: 'reviewdog-suggester'
  level:
    description: 'Report level for reviewdog [info,warning,error]'
    default: 'warning'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is diff_context. GitHub suggestions only support added and diff_context.
    default: 'diff_context'
  reviewdog_flags:
    description: 'Additional reviewdog flags'
    default: ''
  ### Flags for reviewdog suggester ###
  cleanup:
    description: 'Clean up non-committed changes after the action'
    default: 'true'
```

## Required Permissions

The action requires the following permissions:

```yaml
permissions:
  contents: read
  checks: write
  issues: write
  pull-requests: write
```

See [Assigning permissions to jobs](https://docs.github.com/en/actions/using-jobs/assigning-permissions-to-jobs) for more details.

## Usage Example

```yaml
name: reviewdog-suggester
on: [pull_request] # Support only pull_request event.
jobs:
  go:
    name: runner / suggester / gofmt
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: gofmt -w -s .
      - uses: reviewdog/action-suggester@v1
        with:
          tool_name: gofmt
  shell:
    name: runner / suggester / shell
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v4
      - run: go install mvdan.cc/sh/v3/cmd/shfmt@latest

      - run: shfmt -i 2 -ci -w .
      - name: suggester / shfmt
        uses: reviewdog/action-suggester@v1
        with:
          tool_name: shfmt

      # Need to install latest shellcheck to use diff output format as of writing (2020/08/03).
      - name: install shellcheck
        run: |
          scversion="latest"
          wget -qO- "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv
          sudo cp "shellcheck-${scversion}/shellcheck" /usr/local/bin/
          rm -rf "shellcheck-${scversion}/shellcheck"
      - run: shellcheck -f diff $(shfmt -f .) | patch -p1
      - name: suggester / shellcheck
        uses: reviewdog/action-suggester@v1
        with:
          tool_name: shellcheck
```
