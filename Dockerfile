# Build development environment
# docker build --tag sparrow-buildpack .

# Launch development environment
# docker run --rm --tty --user blues --volume "$(pwd)":/host-volume/ sparrow-buildpack

# Define global arguments
ARG DEBIAN_FRONTEND="noninteractive"

# POSIX compatible (Linux/Unix) base image
FROM debian:stable-slim

# Import global arguments
ARG DEBIAN_FRONTEND

# Define local arguments
ARG GCC_ARM_VERSION="10.3-2021.10"
ARG GCC_ARM_CHECKSUM="2383e4eb4ea23f248d33adc70dc3227e"

# Establish development environment
RUN ["dash", "-c", "\
    apt-get update --quiet \
 && apt-get install --assume-yes --no-install-recommends --quiet \
     bzip2 \
     ca-certificates \
     cmake \
     curl \
     git \
     make \
 && apt-get clean \
 && apt-get purge \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
"]
WORKDIR /root

# Download/Install ARM Cross Compiler
RUN ["dash", "-c", "\
    curl -SLO# https://developer.arm.com/-/media/Files/downloads/gnu-rm/${GCC_ARM_VERSION}/gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2 \
 && md5sum gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2 \
 && echo \"${GCC_ARM_CHECKSUM} gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2\" | md5sum -c - \
 && tar -xjf gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2 -C /opt \
 && mv /opt/gcc-arm-none-eabi-${GCC_ARM_VERSION}/ /opt/gcc-arm \
 && rm -rf gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2 \
"]
ENV PATH="/opt/gcc-arm/bin:${PATH}"

# Create Non-Root User
RUN ["dash", "-c", "\
    addgroup \
     --gid 1000 \
     \"blues\" \
 && adduser \
     --disabled-password \
     --gecos \"\" \
     --ingroup \"blues\" \
     --uid 1000 \
     \"blues\" \
"]

# Set Execution Environment
WORKDIR /host-volume

# Build On Invocation (default)
CMD ["dash", "-c", "\
    rm -rf build/ \
 && mkdir build \
 && cd build/ \
 && cmake .. \
 && make -j \
"]
