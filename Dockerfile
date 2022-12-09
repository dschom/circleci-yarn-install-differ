ARG DOCKER_IMAGE=cimg/node:16.13
FROM $DOCKER_IMAGE

ARG BEHAVIOR=throw
ARG DOCKER_USER=root

USER $DOCKER_USER
COPY . .

# The fix - uncomment following to fix checksum issue
# RUN corepack enable

RUN YARN_CHECKSUM_BEHAVIOR=$BEHAVIOR yarn install

