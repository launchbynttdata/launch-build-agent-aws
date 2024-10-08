FROM ghcr.io/launchbynttdata/launch-build-agent-base:latest as base
ARG LAUNCH_PROVIDER="aws"

ENV TOOLS_DIR="/home/launch/tools" \
    IS_PIPELINE=true \
    BUILD_ACTIONS_DIR="${TOOLS_DIR}/launch-build-agent/components/build-actions" \
    PATH="$PATH:${BUILD_ACTIONS_DIR}"

COPY ./.tool-versions "${TOOLS_DIR}/launch-build-agent/.tool-versions"
COPY "./Makefile" "${TOOLS_DIR}/launch-build-agent/Makefile"

# Install aws-cli
USER root
ARG TARGETARCH
COPY ./scripts/install-awscliv2-${TARGETARCH}.sh ${TOOLS_DIR}/launch-build-agent/install-awscliv2-${TARGETARCH}.sh
RUN ${TOOLS_DIR}/launch-build-agent/install-awscliv2-${TARGETARCH}.sh
USER launch

RUN rm -fr .repo/ components/ awscliv2.zip \
    && cd "${TOOLS_DIR}/launch-build-agent" \
    && make git-config \
    && make configure

FROM base AS final

RUN echo "Built image for: ${LAUNCH_PROVIDER}"
