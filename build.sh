#! /bin/bash

# Load image name from command line
[ -z "$1" ] && IMAGE_NAME="kbs_ros_kinetic" || IMAGE_NAME="$1"

echo "Building '$IMAGE_NAME' image for user $USER"
docker build -t "$IMAGE_NAME" --build-arg USERNAME=$USER --build-arg UID=$(id -u $USER) --build-arg GID=$(id -g $USER) . && echo -e "Done!\nList available images with 'docker images'" || echo 'Build failed!'