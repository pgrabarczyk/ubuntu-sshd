FROM ubuntu:latest AS ubuntu_sshd_dbt

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y openssh-server sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test
RUN echo 'test:test' | chpasswd

RUN service ssh start
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]