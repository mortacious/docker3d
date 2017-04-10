# kbs\_docker
Creating Docker containers with ROS kinetic and the KBS-Software from the <https://launchpad.net/~kbs/+archive/ubuntu/kbs> PPA preinstalled. Supports hardware acceleration for running rviz and gazebo.

## Usage:
 1. run `build.sh` in the same folder as the `Dockerfile`
 2. run `create.sh` to create the docker container (e.g. at startup). This script will create the /home/$USER/ros_workspace folder if not present
 3. run `start.sh` to start the created container
 4. run `docker exec -it <container-name> bash` to enter the container
