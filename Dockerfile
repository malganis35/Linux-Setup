FROM ubuntu:latest
LABEL maintainer="Cao Tri DO"

# This docker image is an example of ubuntu basic machine to test any installation from scratch
# The default username and password are docker

RUN apt-get update && \
      apt-get -y install sudo wget curl nano make

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

USER docker
CMD /bin/bash
# WORKDIR "/home/docker"

COPY Makefile /home/docker/Makefile