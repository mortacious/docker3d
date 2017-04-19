#! /bin/bash

[ -z "$2" ] && IMAGE_NAME="kbs_ros_kinetic" || IMAGE_NAME="$2"
[ -z "$1" ] && CONTAINER_NAME="kbs_ros_kinetic-c" || CONTAINER_NAME="$1"

CONTAINER_ID=$(docker ps -q --filter="name=^.?${CONTAINER_NAME}\$")
[ -n "$CONTAINER_ID" ] && echo "Stopping container '$CONTAINER_NAME'" && docker stop "$CONTAINER_ID"
CONTAINER_ID=$(docker ps -aq --filter="name=^.?${CONTAINER_NAME}\$")
[ -n "$CONTAINER_ID" ] && echo "Destroying container '$CONTAINER_NAME'" && docker rm "$CONTAINER_ID"

PARAMETERS="--privileged -e DISPLAY=$DISPLAY --name=$CONTAINER_NAME -u $USER -w /home/$USER -i -t"

[ -d "/dev/dri" ] && PARAMETERS="$PARAMETERS --device=/dev/dri:/dev/dri:rw"
[ -d "/tmp/.X11-unix" ] && PARAMETERS="$PARAMETERS --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw"
[ -d "/var/run" ] && PARAMETERS="$PARAMETERS --volume=/var/run:/var/run:rw"
[ -d "/dev" ] && PARAMETERS="$PARAMETERS --volume=/dev:/dev:rw"
[ ! -d "/home/$USER/ros_workspace" ] && mkdir -p "/home/$USER/ros_workspace"
PARAMETERS="$PARAMETERS --volume=/home/$USER/ros_workspace:/home/$USER/ros_workspace:rw --network=host"


command_exists () {
    type "$1" &> /dev/null ;
}

echo "Creating container '$CONTAINER_NAME' from image '$IMAGE_NAME'"
DOCKER_CMD="docker"
if command_exists nvidia-docker; then
    echo "using nvidia-docker"
    DOCKER_CMD="nvidia-docker"
fi

$DOCKER_CMD create $PARAMETERS "$IMAGE_NAME" /bin/bash && echo -e "Done!\nList 
containers with 'docker ps -a'" || echo 'Failed!'
