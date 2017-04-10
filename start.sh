#!/bin/bash
[ -z "$1" ] && CONTAINER_NAME="kbs_ros_kinetic-c" || CONTAINER_NAME="$1"

command_exists () {
    type "$1" &> /dev/null ;
}
DOCKER_CMD="docker"
if command_exists nvidia-docker; then
    DOCKER_CMD="nvidia-docker"
fi

xhost si:localuser:$USER
echo "Starting container '$CONTAINER_NAME'"
$DOCKER_CMD start "$CONTAINER_NAME"