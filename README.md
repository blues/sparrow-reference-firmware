Sparrow Accelerator Sensor Firmware
===================================

Prerequisites
-------------

### Hardware

- Sparrow Gateway (See [here](https://www.notion.so/Sparrow-sensor-1-0-Gateway-conversion-rework-10-9-21-51f3efa18a5443b5960ac711e634741e) if reworking a v1.0 sensor board as gateway)
- Sparrow Reference Sensor
- Notecard (preferably Note-WiFi)
- Notecarrier
- STLINK-V3MINI
- FTDI Cable
- (2x) AAA batteries

### Software

- Recursively clone the [Sparrow Accelerator Sensor Firmware](https://github.com/blues/sparrow-accelerator-sensor-firmware) repository.

  ```
  git clone https://github.com/blues/sparrow-accelerator-sensor-firmware.git --recursive
  ```

**Containerized Development Environment (Linux Only)**

- [Docker](https://docs.docker.com/engine/install/).
- [VSCode “Remote - Containers” Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

**Native Installation**

- CMake (must be v3.14 or greater)
- Make
- [ST-LINK GDB Server (via STMCubeIDE)](https://www.st.com/en/development-tools/stm32cubeide.html)
- [STM32CubeProg](https://www.st.com/en/development-tools/stm32cubeprog.html)
- [GNU ARM toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads)
- [VSCode “Cortex Debug” Extension](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)

> _**NOTE:** Be sure to add/install all tools/libraries into your system path._
>
> _This may be necessary of all tools, but is especially important for `ST-LINK_gdbserver` and it’s shared library dependency, `libSTLinkUSBDriver.so` (or platform specific equivalent)._

VSCode Instructions
------------------

### Utilizing the Containerized Development Environment (Linux Only)

> _**NOTE:** Be sure to attach your Sparrow device to your machine before you launch the development environment, so `/dev/bus/usb` can be captured by the container._

1. Once you have installed the “Remote - Containers” VSCode extension, then you can click the small green box in the lower-left corner of the VSCode window.
2. Then select “Reopen in Container” from the dropdown menu.

### Build Sparrow Firmware

Hotkey: `Ctrl+Shift+B`

Navigate to, **Terminal > Run Build Task...**

**OR**

1. Navigate to, **Terminal > Run Task...**
2. Select, **Sparrow: Build Firmware Using CMake and Make**

### Install Sparrow Firmware

1. Navigate to, **Terminal > Run Task...**
2. Select, **Sparrow: Flash Firmware Using STM32_Programmer_CLI**

### Debug Sparrow Firmware

Hotkey: `Ctrl+Shift+D`

1. Select **Run and Debug** menu from the leftmost toolbar.
2. Press the green “Play” button next to **Cortex Debug**.

STM32CubeIDE Instructions
-------------------------

### Load the project into your workspace

1. Open the STM32CubeIDE application.
2. Navigate to **File > Open Projects from File System....**
3. Press the **Directory...** button.
4. Open the hidden folder, `.STM32CubeIDE`, from the newly cloned repository.
5. Press the **Finish** button.

### Build Sparrow Firmware

1. Select the `sparrow` project
2. Click the hammer icon to **Build 'Debug' for project 'sparrow'**.

### Install Sparrow Firmware

1. Select the `sparrow` project
2. Click the play icon (green circle with white triangle) to **Run Device Debug**.

### Debug Sparrow Firmware

1. Select the `sparrow` project
2. Click the bug icon to **Debug Device Debug**.
