FROM ubuntu:latest AS ubuntu_sshd

ARG USERNAME
ARG CLIENT_DOCKER_FILES_CLIENT_PATH
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y openssh-server sudo vim \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $CLIENT_DOCKER_FILES_CLIENT_PATH
COPY scripts/* $CLIENT_DOCKER_FILES_CLIENT_PATH/

RUN /bin/bash $CLIENT_DOCKER_FILES_CLIENT_PATH/configure_ssh_user.sh "${USERNAME}" "${CLIENT_DOCKER_FILES_CLIENT_PATH}"

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]