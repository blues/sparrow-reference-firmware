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

# Define global arguments
ARG DEBIAN_FRONTEND="noninteractive"
ARG UID=1000
ARG USER="blues"

# POSIX compatible (Linux/Unix) base image
FROM debian:stable-slim

# Import global arguments
ARG DEBIAN_FRONTEND
ARG UID
ARG USER

# Define local arguments
ARG STM32CUBEIDE_CHECKSUM="565075a54e5438e950f351270ab4f5f6"

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

# Establish development environment
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
     udev \
     unzip \
 && apt-get clean \
 && apt-get purge \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
"]
WORKDIR /root

# Download/Install STM32CubeIDE (packages GNU ARM Compiler, STM32 Programmer CLI, and ST-LINK GDB Server)
RUN ["dash", "-c", "\
    curl -SLO# https://www.st.com/content/ccc/resource/technical/software/sw_development_suite/group0/49/6d/3d/62/eb/0d/42/4b/stm32cubeide_deb/files/st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip/jcr:content/translations/en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip \
 && md5sum en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip \
 && echo \"${STM32CUBEIDE_CHECKSUM} en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip\" | md5sum -c - \
 && unzip en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip -d STM32CubeIDE-1.8.0 \
 && chmod +x STM32CubeIDE-1.8.0/st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh \
 && yes | LICENSE_ALREADY_ACCEPTED=1 STM32CubeIDE-1.8.0/st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh \
 && rm -rf en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip STM32CubeIDE-1.8.0/ \
"]
ENV PATH=/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.linux64_2.0.100.202110141430/tools/bin:${PATH}
ENV PATH=/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.9-2020-q2-update.linux64_2.0.0.202105311346/tools/bin:${PATH}
ENV PATH=/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.linux64_2.0.100.202109301221/tools/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.linux64_2.0.100.202109301221/tools/bin/native/linux_x64:${LD_LIBRARY_PATH}

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
