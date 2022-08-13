#!/usr/bin/env bash
# # Configure SSH User
set -eu -o pipefail -E

USERNAME=$1
echo "USERNAME: ${USERNAME}"
USER_HOME="/home/${USERNAME}"

CLIENT_DOCKER_FILES_CLIENT_PATH=$2
echo "CLIENT_DOCKER_FILES_CLIENT_PATH: ${CLIENT_DOCKER_FILES_CLIENT_PATH}"

useradd -rm -d "${USER_HOME}" -s /bin/bash -g root -G sudo -u 1000 "${USERNAME}"
mkdir –p "${USER_HOME}/.ssh"
chmod 0700 "${USER_HOME}/.ssh"
touch "${USER_HOME}/.ssh/authorized_keys"
chown -R "${USERNAME}" "${USER_HOME}"

# Disable Password Authentication and enable using keys
sed -i "/.*PubkeyAuthentication.*/d"       /etc/ssh/sshd_config
sed -i "/.*PasswordAuthentication.*/d"     /etc/ssh/sshd_config
sed -i "/.*PermitRootLogin.*/d"            /etc/ssh/sshd_config
echo "PubkeyAuthentication yes"   | tee -a /etc/ssh/sshd_config
echo "PasswordAuthentication no"  | tee -a /etc/ssh/sshd_config
echo "PermitRootLogin no"         | tee -a /etc/ssh/sshd_config

service ssh start