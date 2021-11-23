# Container with dependencies necessary to run the CI build

# Build development environment
# $ docker build . --tag sparrow-ci

# Launch development environment (mount source root as /note-arduino/)
# $ docker run --rm --volume $(pwd)/../../../:/sparrow-lora/ --workdir /sparrow-lora/ sparrow-ci

# Launch with interactive shell
# $ docker run -it --rm --volume $(pwd)/../../../:/sparrow-lora/ --workdir /sparrow-lora/ sparrow-ci --entrypoint /bin/ash

# $ docker run -it --rm sparrow-ci /bin/ash

# Base Image
FROM alpine

# the version in the alpine package fails to build, with nano.specs not found
RUN apk --update --no-cache upgrade && \
    apk --no-cache add make cmake gcc-arm-none-eabi newlib-arm-none-eabi

ENTRYPOINT [ "./cmake-build.sh" ]