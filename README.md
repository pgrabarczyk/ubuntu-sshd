# ubuntu-sshd

# Prerequisites 

## Generate SSH keys
```bash
# Execute from repo dir
# should generate docker_key & docker_key.pub
ssh-keygen -q -t ecdsa -b 521 -N '' -f "$(pwd)/ssh_keys/docker_key" <<<y >/dev/null 2>&1 
```

# Build image & run
```bash
export IMAGE_NAME='ubuntu_sshd'
export IMAGE_SSH_USERNAME='ubuntu'
export CONTAINER_NAME='ubuntu_sshd'

export HOST_SSH_KEYS_ABSOLUTE_PATH="$(pwd)/ssh_keys"
export CLIENT_DOCKER_FILES_CLIENT_PATH='/opt/docker_files'

docker build -t "${IMAGE_NAME}" \
  --build-arg USERNAME="${IMAGE_SSH_USERNAME}" \
  --build-arg CLIENT_DOCKER_FILES_CLIENT_PATH .

docker run -d --publish 22:22 --name "${CONTAINER_NAME}" \
  -v $HOST_SSH_KEYS_ABSOLUTE_PATH/docker_key.pub:/home/$IMAGE_SSH_USERNAME/.ssh/authorized_keys "${IMAGE_NAME}"
  
export CONTAINER_ID="$(docker ps | grep -i $IMAGE_NAME | awk '{print $1}')"
export CONTAINER_IP="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "${CONTAINER_IP}" || true # delete from known_hosts if already exists - for developing purposes
ssh-keyscan -H "${CONTAINER_IP}" >> ~/.ssh/known_hosts
```

Execute
```bash
ssh -i ssh_keys/docker_key "$IMAGE_SSH_USERNAME@$CONTAINER_IP"
```

OR
```bash
# ssh -i ssh_keys/docker_key "$IMAGE_SSH_USERNAME@$CONTAINER_IP" <any command>
ssh -i ssh_keys/docker_key "$IMAGE_SSH_USERNAME@$CONTAINER_IP" cat /etc/*-release | grep DISTRIB_DESCRIPTION
```

# Cleanup ALL

Stop & remove ALL! containers & this image
```bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi "${IMAGE_NAME}"
```

# Troubleshooting
```bash
ssh -Q key
ssh -vvv "$IMAGE_SSH_USERNAME@$CONTAINER_IP" -i ssh_keys/docker_key
```
