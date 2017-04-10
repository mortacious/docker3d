# ros kinetic base container
FROM osrf/ros:kinetic-desktop
MAINTAINER Felix Igelbrink

ARG USERNAME=mortacious
ARG UID=100
ARG GID=1000

# ===== set environment variables ===== 
# Use the "noninteractive" debconf frontend
ENV DEBIAN_FRONTEND noninteractive
#ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:$#{LD_LIBRARY_PATH}
ENV QT_GRAPHICSSYSTEM native
ENV QT_X11_NO_MITSHM 1
#ENV PATH /usr/local/nvidia/bin:${PATH}
LABEL com.nvidia.volumes.needed="nvidia_driver"

# Ros specify environment settings
ENV PATH $PATH:/opt/ros/kinetic/bin

RUN echo "$USERNAME, $UID, $GID"
# ===== create user environment ===== 
RUN  export uid=$UID gid=$GID username=$USERNAME && \
     mkdir -p /home/$username && \
     mkdir -p /etc/sudoers.d && \
     echo "${username}:x:${uid}:${gid}:${username},,,:/home/${username}:/bin/bash" >> /etc/passwd && \
     echo "${username}:x:${uid}:" >> /etc/group && \
     echo "${username} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${username} && \
     chmod 0440 /etc/sudoers.d/${username} && \
     chown ${uid}:${gid} -R /home/${username}

# ===== install packages ===== 
RUN apt-get update && apt-get install -y bash-completion git software-properties-common python-software-properties && add-apt-repository --yes ppa:kbs/kbs && \ 
    add-apt-repository --yes ppa:xqms/opencv-nonfree &&  apt-get update && apt-get install -y \
	debhelper kbs-software sudo binutils mesa-utils\
	python-catkin-tools tmux

# Try to test bumblebee (optional)
#RUN apt-get install -y bumblebee nvidia-current bumblebee-nvidia
# ===== additional commands ===== 

# switch to local user 
USER $USERNAME
# ===== prepare ROS system ====
RUN echo "source /opt/ros/kinetic/setup.bash" > /home/$USERNAME/.bashrc && rosdep update

 
