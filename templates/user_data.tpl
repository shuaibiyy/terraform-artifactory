#!/bin/bash

# Install s3fs-fuse
sudo apt-get install -y build-essential git libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool python-pip
sudo apt-get install -y pkg-config libssl-dev
git clone https://github.com/s3fs-fuse/s3fs-fuse /home/ubuntu/s3fs-fuse
cd /home/ubuntu/s3fs-fuse
./autogen.sh
./configure --prefix=/usr --with-openssl
make
sudo make install

# Mount s3 bucket on /data directory
mkdir -p /home/ubuntu/.s3fs
echo ${access_key}:${secret_key} > /home/ubuntu/.s3fs/passwd
chmod 600 /home/ubuntu/.s3fs/passwd
sudo mkdir -p /data
sudo chmod 600 /data
sudo s3fs ${s3_bucket} /data -o passwd_file=/home/ubuntu/.s3fs/passwd,nonempty

# Install Docker
curl -fsSL https://get.docker.com/ | sh

# Start Artifactory docker container
sudo docker run -id -e RUNTIME_OPTS="-Xms512m -Xmx1024m" \
    --name="artifactory" -p 80:8080 \
    -v /data/artifactory/data:/artifactory/data \
    -v /data/artifactory/logs:/artifactory/logs \
    -v /data/artifactory/backup:/artifactory/backup \
    mattgruter/artifactory
