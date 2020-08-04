FROM alpine:3.12

ENV REVIEWDOG_VERSION=v0.10.2

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git

# TODO(haya14busa): Use released version of reviewdog instead of nightly.
# RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/nightly/master/install.sh| sh -s -- -b /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
