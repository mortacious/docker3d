FROM ubuntu:14.04
MAINTAINER github/ojgarciab

# Based on http://gernotklingler.com/blog/docker-replaced-virtual-machines-chroots/

# Change repositorios to spanish (optional)
RUN sed -i 's/\/archive\.ubuntu\.com/\/es.archive.ubuntu.com/g' /etc/apt/sources.list
# Update packages
RUN apt-get update

# Use the "noninteractive" debconf frontend
ENV DEBIAN_FRONTEND noninteractive

# ===== create user/setup environment =====
# Replace 1000 with your user/group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/redstar && \
    echo "redstar:x:${uid}:${gid}:redstar,,,:/home/redstar:/bin/bash" >> /etc/passwd && \
    echo "redstar:x:${uid}:" >> /etc/group && \
    echo "redstar ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/redstar && \
    chmod 0440 /etc/sudoers.d/redstar && \
    chown ${uid}:${gid} -R /home/redstar

# ===== Install additional packages =====
RUN apt-get -y install bash-completion git build-essential vim

# ===== install graphics driver&co for accelerated 3d support (optional) =====
# install nvidia driver
RUN apt-get install -y binutils mesa-utils
# Try to test bumblebee (optional)
RUN apt-get install -y bumblebee nvidia-current bumblebee-nvidia
    
# some QT-Apps/Gazebo don't not show controls without this
ENV QT_X11_NO_MITSHM 1

ENV HOME /home/redstar
ENV USER redstar
USER redstar
