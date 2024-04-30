ARG LAUNCH_PROVIDER="aws"

FROM ghcr.io/launchbynttdata/launch-build-agent-base:latest as base

ENV TOOLS_DIR="/usr/local/opt" \
    IS_PIPELINE=true

COPY "./Makefile" "${TOOLS_DIR}/launch-build-agent/Makefile"
ENV BUILD_ACTIONS_DIR="${TOOLS_DIR}/launch-build-agent/components/build-actions" \
    PATH="$PATH:${BUILD_ACTIONS_DIR}" \
    JOB_NAME="${GIT_USERNAME}" \
    JOB_EMAIL="${GIT_USERNAME}@${GIT_EMAIL_DOMAIN}"
RUN cd /usr/local/opt/launch-build-agent \
    && make git-config \
    && make configure

FROM base AS final

RUN echo "Built image for: ${LAUNCH_PROVIDER}"
