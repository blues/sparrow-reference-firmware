# Copyright 2022 Blues Inc.  All rights reserved.
# Use of this source code is governed by licenses granted by the
# copyright holder including that found in the LICENSE file.

# Build development environment
# docker build --tag sparrow-buildpack .

# Compile Sparrow firmware
# docker run --rm --tty --user blues --volume "$(pwd)":/host-volume/ sparrow-buildpack

# Launch development environment
# docker run --device /dev/bus/usb/ --interactive --rm --tty --user blues --volume "$(pwd)":/host-volume/ sparrow-buildpack bash

# Define global arguments
ARG DEBIAN_FRONTEND="noninteractive"

# POSIX compatible (Linux/Unix) base image
FROM debian:stable-slim

# Import global arguments
ARG DEBIAN_FRONTEND

# Define local arguments
ARG GCC_ARM_VERSION="10.3-2021.10"
ARG GCC_ARM_CHECKSUM="2383e4eb4ea23f248d33adc70dc3227e"
ARG STM32CUBEIDE_CHECKSUM="565075a54e5438e950f351270ab4f5f6"
ARG STM32CUBEPROG_CHECKSUM="7c53892086c29a9eaf2710578ce57f69"

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

# Download/Install ARM Cross Compiler
# RUN ["dash", "-c", "\
#     curl -SLO# https://developer.arm.com/-/media/Files/downloads/gnu-rm/${GCC_ARM_VERSION}/gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2 \
#  && md5sum gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2 \
#  && echo \"${GCC_ARM_CHECKSUM} gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2\" | md5sum -c - \
#  && tar -xjf gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2 -C /opt \
#  && mv /opt/gcc-arm-none-eabi-${GCC_ARM_VERSION}/ /opt/gcc-arm \
#  && rm -rf gcc-arm-none-eabi-${GCC_ARM_VERSION}-x86_64-linux.tar.bz2 \
# "]
# ENV PATH="/opt/gcc-arm/bin:${PATH}"

# Download/Install STM32CubeProg Utilities
RUN ["dash", "-c", "\
    curl -SLO# https://www.st.com/content/ccc/resource/technical/software/utility/group0/af/f8/e3/60/56/b9/42/9d/stm32cubeprg-lin_v2-9-0/files/stm32cubeprg-lin_v2-9-0.zip/jcr:content/translations/en.stm32cubeprg-lin_v2-9-0.zip \
 && md5sum en.stm32cubeprg-lin_v2-9-0.zip \
 && echo \"${STM32CUBEPROG_CHECKSUM} en.stm32cubeprg-lin_v2-9-0.zip\" | md5sum -c - \
 && unzip en.stm32cubeprg-lin_v2-9-0.zip -d STM32CubeProgrammer-2.9.0 \
 && printf \"1\\n1\\n1\\n\\nO\\n1\\nY\\nN\\nN\\n1\\nN\\nN\\n\" | STM32CubeProgrammer-2.9.0/SetupSTM32CubeProgrammer-2.9.0.linux \
 && rm -rf en.stm32cubeprg-lin_v2-9-0.zip STM32CubeProgrammer-2.9.0/ \
"]
ENV PATH=/usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin:${PATH}

# Download/Install STM32CubeIDE (ST-LINK GDB Server)
RUN ["dash", "-c", "\
    curl -SLO# https://www.st.com/content/ccc/resource/technical/software/sw_development_suite/group0/49/6d/3d/62/eb/0d/42/4b/stm32cubeide_deb/files/st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip/jcr:content/translations/en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip \
 && md5sum en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip \
 && echo \"${STM32CUBEIDE_CHECKSUM} en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip\" | md5sum -c - \
 && unzip en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip -d STM32CubeIDE-1.8.0 \
 && chmod +x STM32CubeIDE-1.8.0/st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh \
 && yes | LICENSE_ALREADY_ACCEPTED=1 STM32CubeIDE-1.8.0/st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh \
 && rm -rf en.st-stm32cubeide_1.8.0_11526_20211125_0815_amd64.deb_bundle.sh.zip STM32CubeIDE-1.8.0/ \
"]
ENV PATH=/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.linux64_2.0.100.202109301221/tools/bin:${PATH}
ENV PATH=/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.9-2020-q2-update.linux64_2.0.0.202105311346/tools/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.linux64_2.0.100.202109301221/tools/bin/native/linux_x64:${LD_LIBRARY_PATH}

# Add `udev` Rules for STMicroelectronics
RUN ["dash", "-c", "\
    echo \"# Serial Connection (Circuit Python for STM32 MCUs)\" > /etc/udev/rules.d/49-stcpy-permissions.rules \
 && echo \"SUBSYSTEM==\\\"usb\\\", ATTRS{idVendor}==\\\"30a4\\\", ATTRS{idProduct}==\\\"0002\\\", MODE=\\\"0664\\\", GROUP=\\\"dialout\\\"\" >> /etc/udev/rules.d/49-stcpy-permissions.rules \
 && echo \"# DFU (Internal bootloader for STM32 MCUs)\" > /etc/udev/rules.d/49-stdfu-permissions.rules \
 && echo \"SUBSYSTEM==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"df11\\\", MODE=\\\"0664\\\", GROUP=\\\"plugdev\\\"\" >> /etc/udev/rules.d/49-stdfu-permissions.rules \
 && echo \"# stm32 discovery boards, with onboard st/linkv1\" > /etc/udev/rules.d/49-stlinkv1.rules \
 && echo \"# ie, STM32VL.\" >> /etc/udev/rules.d/49-stlinkv1.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv1.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"3744\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv1.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv1.rules \
 && echo \"    SYMLINK+=\\\"stlinkv1_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv1.rules \
 && echo \"# stm32 discovery boards, with onboard st/linkv2\" > /etc/udev/rules.d/49-stlinkv2.rules \
 && echo \"# ie, STM32L, STM32F4.\" >> /etc/udev/rules.d/49-stlinkv2.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv2.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"3748\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv2.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv2.rules \
 && echo \"    SYMLINK+=\\\"stlinkv2_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv2.rules \
 && echo \"# stm32 nucleo boards, with onboard st/linkv2-1\" > /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"# ie, STM32F0, STM32F4.\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"374b\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"    SYMLINK+=\\\"stlinkv2-1_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"3752\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"    SYMLINK+=\\\"stlinkv2-1_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv2-1.rules \
 && echo \"# stlink-v3 boards (standalone and embedded) in usbloader mode and standard (debug) mode\" > /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"374d\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    SYMLINK+=\\\"stlinkv3loader_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"374e\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    SYMLINK+=\\\"stlinkv3_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"374f\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    SYMLINK+=\\\"stlinkv3_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"3753\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    SYMLINK+=\\\"stlinkv3_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"3754\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    SYMLINK+=\\\"stlinkv3_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"3755\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    SYMLINK+=\\\"stlinkv3loader_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"SUBSYSTEMS==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"3757\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    MODE=\\\"660\\\", GROUP=\\\"plugdev\\\", TAG+=\\\"uaccess\\\", ENV{ID_MM_DEVICE_IGNORE}=\\\"1\\\", \\\\\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"    SYMLINK+=\\\"stlinkv3_%n\\\"\" >> /etc/udev/rules.d/49-stlinkv3.rules \
 && echo \"# Virtual COM Port for STM32 MCUs\" > /etc/udev/rules.d/49-stvcp-permissions.rules \
 && echo \"SUBSYSTEM==\\\"usb\\\", ATTRS{idVendor}==\\\"0483\\\", ATTRS{idProduct}==\\\"5740\\\", MODE=\\\"0664\\\", GROUP=\\\"plugdev\\\"\" >> /etc/udev/rules.d/49-stvcp-permissions.rules \
"]

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
 && usermod \
     --append \
     --groups \"dialout,plugdev\" \
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
