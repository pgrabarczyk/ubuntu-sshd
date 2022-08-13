#!/usr/bin/env bash
set -eu -o pipefail -E

docker stop $(docker ps -a -q) || true
docker rm $(docker ps -a -q) || true
docker rmi "${IMAGE_NAME}" || true

export IMAGE_NAME='ubuntu_sshd_dbt'
export IMAGE_SSH_USERNAME='ubuntu'
export CONTAINER_NAME='ubuntu_sshd_dbt'
docker build -t "${IMAGE_NAME}" --build-arg USERNAME="${IMAGE_SSH_USERNAME}" .
docker run -d --publish 22:22 --name "${CONTAINER_NAME}" "${IMAGE_NAME}"
export CONTAINER_ID="$(docker ps | grep -i $IMAGE_NAME | awk '{print $1}')"
export CONTAINER_IP="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)"
ssh-keygen -f "/home/pgrabarczyk/.ssh/known_hosts" -R "${CONTAINER_IP}" || true # delete from known_hosts if already exists - for developing purposes
ssh-keyscan -H "${CONTAINER_IP}" >> ~/.ssh/known_hosts

ssh -vvv "$IMAGE_SSH_USERNAME@$CONTAINER_IP" -i ssh_keys/docker_key