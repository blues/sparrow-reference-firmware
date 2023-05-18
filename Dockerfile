# Copyright 2022 Blues Inc.  All rights reserved.
# Use of this source code is governed by licenses granted by the
# copyright holder including that found in the LICENSE file.

# Build development environment
# docker build --tag sparrow-buildpack .

# Compile Sparrow firmware
# docker run --rm --tty --user blues --volume "$(pwd)":/host-volume/ sparrow-buildpack

# Launch development environment
# docker run --device /dev/bus/usb/ --interactive --rm --tty --user blues --volume "$(pwd)":/host-volume/ sparrow-buildpack bash

# _**NOTE:** In order to utilize DFU and debugging functionality, you must
# install (copy) the `.rules` file related to your debugging probe into the
# `/etc/udev/rules.d` directory of the host machine and restart the host._

# Global Argument(s)
ARG DEBIAN_FRONTEND="noninteractive"
ARG UID=1000
ARG USER="blues"

# POSIX Compatible (Linux/Unix) Base Image
FROM debian:stable-slim

# Import Global Argument(s)
ARG DEBIAN_FRONTEND
ARG UID
ARG USER

# Local Argument(s)
ARG STM32CUBECLT_CHECKSUM="e6c3c5a0fb2583e43b4b58dfdbd49ecd"
ARG STM32CUBECLT_DIRECTORY="en.st-stm32cubeclt_1.12.1_16088_20230420_1057_amd64.deb_bundle.sh"
ARG STM32CUBECLT_DOWNLOAD_URL="https://www.st.com/content/ccc/resource/technical/software/application_sw/group0/ae/01/45/d5/38/03/4c/be/STM32CubeCLT-DEB/files/st-stm32cubeclt_1.12.1_16088_20230420_1057_amd64.deb_bundle.sh.zip/jcr:content/translations/en.st-stm32cubeclt_1.12.1_16088_20230420_1057_amd64.deb_bundle.sh.zip"
ARG STM32CUBECLT_INSTALL_SCRIPT="st-stm32cubeclt_1.12.1_16088_20230420_1057_amd64.deb_bundle.sh"

# Create Non-Root User
RUN ["dash", "-c", "\
    addgroup \
     --gid ${UID} \
     \"${USER}\" \
 && adduser \
     --disabled-password \
     --gecos \"\" \
     --ingroup \"${USER}\" \
     --uid ${UID} \
     \"${USER}\" \
 && usermod \
     --append \
     --groups \"dialout,plugdev\" \
     \"${USER}\" \
"]

# Establish Development Environment
RUN ["dash", "-c", "\
    apt-get update --quiet \
 && apt-get install --assume-yes --no-install-recommends --quiet \
     bzip2 \
     ca-certificates \
     cmake \
     curl \
     git \
     libglib2.0-0 \
     libncurses5 \
     libpython2.7 \
     libusb-1.0-0 \
     libwebkit2gtk-4.0-37 \
     make \
     nano \
     ssh \
     udev \
     unzip \
 && apt-get clean \
 && apt-get purge \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
"]
WORKDIR /root

# Download/Install STM32CUBECLT (packages GNU ARM Compiler, STM32 Programmer CLI, and ST-LINK GDB Server)
RUN ["dash", "-c", "\
    curl --compressed --header 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36' --location --progress-bar --remote-name --show-error ${STM32CUBECLT_DOWNLOAD_URL} \
 && md5sum ${STM32CUBECLT_DIRECTORY}.zip \
 && echo \"${STM32CUBECLT_CHECKSUM} ${STM32CUBECLT_DIRECTORY}.zip\" | md5sum -c - \
 && unzip ${STM32CUBECLT_DIRECTORY}.zip -d ${STM32CUBECLT_DIRECTORY} \
 && chmod +x ${STM32CUBECLT_DIRECTORY}/${STM32CUBECLT_INSTALL_SCRIPT} \
 && yes | LICENSE_ALREADY_ACCEPTED=1 ${STM32CUBECLT_DIRECTORY}/${STM32CUBECLT_INSTALL_SCRIPT} \
 && rm -rf ${STM32CUBECLT_DIRECTORY}.zip ${STM32CUBECLT_DIRECTORY}/ \
"]
ENV PATH=/opt/st/stm32cubeclt_1.12.1/STM32CubeProgrammer/bin:${PATH}
ENV PATH=/opt/st/stm32cubeclt_1.12.1/GNU-tools-for-STM32/bin:${PATH}
ENV PATH=/opt/st/stm32cubeclt_1.12.1/STLink-gdb-server/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/st/stm32cubeclt_1.12.1/STLink-gdb-server/bin/native/linux_x64:${LD_LIBRARY_PATH}

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
