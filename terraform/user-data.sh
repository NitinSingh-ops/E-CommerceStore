#!/bin/bash
set -eux

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu || true

docker network create ecommerce-net || true

docker pull ${dockerhub_username}/ecommerce-user:${docker_tag}
docker pull ${dockerhub_username}/ecommerce-product:${docker_tag}
docker pull ${dockerhub_username}/ecommerce-cart:${docker_tag}
docker pull ${dockerhub_username}/ecommerce-order:${docker_tag}
docker pull ${dockerhub_username}/ecommerce-frontend:${frontend_tag}
docker pull mongo:7

docker rm -f ecommerce-mongodb ecommerce-user ecommerce-product ecommerce-cart ecommerce-order ecommerce-frontend 2>/dev/null || true

docker run -d \
  --name ecommerce-mongodb \
  --network ecommerce-net \
  mongo:7

sleep 10

docker run -d \
  --name ecommerce-user \
  --network ecommerce-net \
  -p 3001:3001 \
  -e MONGODB_URI=mongodb://ecommerce-mongodb:27017/ecommerce_users \
  ${dockerhub_username}/ecommerce-user:${docker_tag}

docker run -d \
  --name ecommerce-product \
  --network ecommerce-net \
  -p 3002:3002 \
  -e MONGODB_URI=mongodb://ecommerce-mongodb:27017/ecommerce_products \
  ${dockerhub_username}/ecommerce-product:${docker_tag}

docker run -d \
  --name ecommerce-cart \
  --network ecommerce-net \
  -p 3003:3003 \
  -e MONGODB_URI=mongodb://ecommerce-mongodb:27017/ecommerce_carts \
  ${dockerhub_username}/ecommerce-cart:${docker_tag}

docker run -d \
  --name ecommerce-order \
  --network ecommerce-net \
  -p 3004:3004 \
  -e MONGODB_URI=mongodb://ecommerce-mongodb:27017/ecommerce_orders \
  ${dockerhub_username}/ecommerce-order:${docker_tag}

docker run -d \
  --name ecommerce-frontend \
  --network ecommerce-net \
  -p 80:80 \
  ${dockerhub_username}/ecommerce-frontend:${frontend_tag}
