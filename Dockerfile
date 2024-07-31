ARG LAUNCH_PROVIDER="aws" \
    TARGETARCH

FROM ghcr.io/launchbynttdata/launch-build-agent-base:latest as base

ENV CONTAINER_REGISTRY="ghcr.io/launchbynttdata" \
    CONTAINER_IMAGE_NAME="launch-build-agent-aws" \
    CONTAINER_IMAGE_VERSION="latest" \
    TOOLS_DIR="/home/launch/tools" \
    IS_PIPELINE=true \
    BUILD_ACTIONS_DIR="${TOOLS_DIR}/launch-build-agent/components/build-actions" \
    PATH="$PATH:${BUILD_ACTIONS_DIR}" \
    JOB_NAME="${GIT_USERNAME}" \
    JOB_EMAIL="${GIT_USERNAME}@${GIT_EMAIL_DOMAIN}"

COPY ./scripts/install-awscliv2-${TARGETARCH}.sh ${TOOLS_DIR}/launch-build-agent/install-awscliv2-${TARGETARCH}.sh
COPY ./.tool-versions "${TOOLS_DIR}/launch-build-agent/.tool-versions"
COPY "./Makefile" "${TOOLS_DIR}/launch-build-agent/Makefile"

# Allows us to rerun repo sync in the AWS manifest context
RUN ${TOOLS_DIR}/launch-build-agent/install-awscliv2-${TARGETARCH}.sh \
    && rm -fr .repo/ components/ awscliv2.zip ./aws \
    && cd "${TOOLS_DIR}/launch-build-agent" \
    && make git-config \
    && make configure

FROM base AS final

RUN echo "Built image for: ${LAUNCH_PROVIDER}"
