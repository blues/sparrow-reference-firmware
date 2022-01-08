Sparrow Sensor Framework
========================

Prerequisites
-------------
1. [Install Docker](https://docs.docker.com/engine/install/) on your build machine.

Build instructions
------------------

1. Build a Docker image from the Dockerfile in this directory

   ```none
   docker build --tag sparrow-buildpack .
   ```

1. Build the Sparrow binary using the Docker image

   ```none
   docker run --rm --tty --user blues --volume "$(pwd)":/host-volume/ sparrow-buildpack
   ```

STM32CubeIDE Instructions
-------------------------

1. Clone the repository
   ```
   git clone https://github.com/blues/sparrow-accelerator-sensor-firmware.git --recursive
   ```
2. Open the STM32CubeIDE application.
3. Navigate to **File > Open Projects from File System....**
4. Press the **Directory...** button.
5. Open the newly cloned repository.
6. Deselect the nested projects (i.e. do _NOT_ import them).
7. Press the **Finish** button.
8. Click the hammer icon to **Build 'Debug' for project 'sparrow'**.
