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
   docker run --rm --tty --volume "$(pwd)":/sparrow-sensor-framework/ sparrow-buildpack
   ```
