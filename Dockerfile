ARG LAUNCH_PROVIDER="aws"

FROM ghcr.io/launchbynttdata/launch-build-agent-base:patch-launch-cli-rebuild as base

ENV CONTAINER_REGISTRY="ghcr.io/launchbynttdata" \
    CONTAINER_IMAGE_NAME="launch-build-agent-aws" \
    CONTAINER_IMAGE_VERSION="latest"

ENV TOOLS_DIR="/home/launch/tools" \
    IS_PIPELINE=true

# Allows us to rerun repo sync in the AWS manifest context
RUN rm -fr .repo/ components/

COPY ./.tool-versions "${TOOLS_DIR}/launch-build-agent/.tool-versions"
COPY "./Makefile" "${TOOLS_DIR}/launch-build-agent/Makefile"
ENV BUILD_ACTIONS_DIR="${TOOLS_DIR}/launch-build-agent/components/build-actions" \
    PATH="$PATH:${BUILD_ACTIONS_DIR}" \
    JOB_NAME="${GIT_USERNAME}" \
    JOB_EMAIL="${GIT_USERNAME}@${GIT_EMAIL_DOMAIN}"
RUN cd "${TOOLS_DIR}/launch-build-agent" \
    && make git-config \
    && make configure

FROM base AS final

RUN echo "Built image for: ${LAUNCH_PROVIDER}"
