#!/bin/bash

docker stop ub1404-dev
docker rm ub1404-dev
docker create --privileged -e "DISPLAY" -v="/dev/nvidiactl:/dev/nvidiactl:rw" -v="/var/run/bumblebee.socket:/var/run/bumblebee.socket:rw" -v="/dev/dri:/dev/dri:rw" -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" -v="/home/redstar:/home/redstar:rw" -u redstar -w /home/redstar -h ub1404-dev --name="ub1404-dev" -i -t ub1404-dev /bin/bash

