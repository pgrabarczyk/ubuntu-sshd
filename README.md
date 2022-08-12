# ubuntu-sshd-dbt

# Build image & run

```bash
export IMAGE_NAME='ubuntu_sshd_dbt'
export IMAGE_SSH_USERNAME='test'
export IMAGE_SSH_PASSWORD='test'
export CONTAINER_NAME='ubuntu_sshd_dbt'
docker build -t "${IMAGE_NAME}" .
docker run -d --publish 22:22 --name "${CONTAINER_NAME}" "${IMAGE_NAME}" 
#docker run -it "${IMAGE_NAME}" bash

export CONTAINER_ID="$(docker ps | grep -i $IMAGE_NAME | awk '{print $1}')"
export CONTAINER_IP="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)"
#echo "CONTAINER_IP = ${CONTAINER_IP}"
ssh "$IMAGE_SSH_USERNAME@$CONTAINER_IP"
```

# Cleanup ALL

Stop & remove ALL! containers
```bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

# TODO
* Change SSH auth method from password to keys
* Install DBT