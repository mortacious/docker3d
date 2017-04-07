# ros kinetic base container
FROM osrf/ros:kinetic-desktop
MAINTAINER Felix Igelbrink

# ===== set environment variables ===== 
# Use the "noninteractive" debconf frontend
ENV DEBIAN_FRONTEND noninteractive
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV QT_GRAPHICSSYSTEM native
ENV QT_X11_NO_MITSHM 1
#ENV PATH /usr/local/nvidia/bin:${PATH}
#LABEL com.nvidia.volumes.needed="nvidia_driver"

# Ros specify environment settings
ENV PATH $PATH:/opt/ros/kinetic/bin

# ===== create user environment ===== 
RUN  export uid=1000 gid=100 && \
     mkdir -p /home/mortacious && \
     mkdir -p /etc/sudoers.d && \
     echo "mortacious:x:${uid}:${gid}:mortacious,,,:/home/mortacious:/bin/bash" >> /etc/passwd && \
     echo "mortacious:x:${uid}:" >> /etc/group && \
     echo "mortacious ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/mortacious && \
     chmod 0440 /etc/sudoers.d/mortacious && \
     chown ${uid}:${gid} -R /home/mortacious

# ===== install packages ===== 
RUN apt-get update && apt-get install -y bash-completion git software-properties-common python-software-properties && add-apt-repository --yes ppa:kbs/kbs && \ 
    add-apt-repository --yes ppa:xqms/opencv-nonfree &&  apt-get update && apt-get install -y \
	debhelper kbs-software sudo binutils mesa-utils\
	python-catkin-tools tmux

# Try to test bumblebee (optional)
#RUN apt-get install -y bumblebee nvidia-current bumblebee-nvidia
# ===== additional commands ===== 

# install nvidia drivers (only for nvidia cards!)
ADD NVIDIA-Linux-x86_64-378.13.run /tmp/NVIDIA-Linux-x86_64-378.13.run
RUN sh /tmp/NVIDIA-Linux-x86_64-378.13.run -a -N --ui=none --no-kernel-module
RUN rm /tmp/NVIDIA-Linux-x86_64-378.13.run

RUN echo "source /opt/ros/kinetic/setup.bash" > /home/mortacious/.bashrc
USER mortacious
 
