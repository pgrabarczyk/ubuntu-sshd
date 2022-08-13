FROM ubuntu:latest AS ubuntu_sshd_dbt

ARG USERNAME
ENV DEBIAN_FRONTEND noninteractive
ENV DOCKER_FILES_CLIENT_PATH /opt/docker_files

RUN apt-get update \
    && apt-get install -y openssh-server sudo vim \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $DOCKER_FILES_CLIENT_PATH
COPY ssh_keys/docker_key.pub $DOCKER_FILES_CLIENT_PATH/docker_key.pub
COPY scripts/* $DOCKER_FILES_CLIENT_PATH/

RUN /bin/bash $DOCKER_FILES_CLIENT_PATH/configure_ssh_user.sh "${USERNAME}" "${DOCKER_FILES_CLIENT_PATH}"

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]