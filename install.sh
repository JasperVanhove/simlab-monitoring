#!/bin/bash

# Install the Docker and docker-compose
# Add Docker's official GPG key:
echo "Installing Docker and docker-compose..."
# Add Docker's official GPG key:
sudo apt-get update && sudo apt upgrade -y
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y

# Add the current user to the docker group
echo "Add the current user to the docker group."
sudo usermod -aG docker $USER

# Verify that Docker Engine is installed correctly by running the hello-world image.
echo "Verify that Docker Engine is installed correctly."
echo "#################################################"
if sudo docker run hello-world 2>&1 | grep -q "Hello from Docker!"; then
    echo "Docker is installed correctly."
else
    echo "Docker is not installed correctly."
fi

# Remove the unused containers
echo "Remove the All existing containers/images/volumes/networks from Docker."
sudo docker system prune -a -f

# Rebooting the system
echo "Rebooting the system."
sudo reboot
