# E-CommerceStore – Multi-Service Node.js Application Deployment

## Project Overview

This project demonstrates the deployment of a multi-service Node.js E-Commerce application using **Docker, Docker Hub, Terraform, and AWS EC2**.

The application consists of four backend microservices, a React frontend, and MongoDB.

## Architecture

```text
                         Internet
                            |
                            | HTTP :80
                            v
                  +----------------------+
                  |      AWS EC2         |
                  |     Ubuntu 24.04     |
                  +----------------------+
                            |
                            v
                  +----------------------+
                  |  React + Nginx       |
                  |     Port 80          |
                  +----------------------+
                     /    /   \    \
                    /    /     \    \
                   v    v       v    v
              User   Product   Cart  Order
              3001    3002     3003   3004
                   \    |       |    /
                    \   |       |   /
                     v  v       v  v
                  +----------------+
                  |    MongoDB     |
                  |     :27017     |
                  +----------------+

Docker Network:
ecommerce-net
```

## Technologies Used

- Node.js
- Express.js
- React
- MongoDB
- Nginx
- Docker
- Docker Hub
- AWS EC2
- AWS VPC
- Terraform
- Ubuntu 24.04 LTS

## Application Services

| Service | Port |
|---|---:|
| User Service | 3001 |
| Product Service | 3002 |
| Cart Service | 3003 |
| Order Service | 3004 |
| Frontend | 80 |
| MongoDB | 27017 |

## Docker Images

| Service | Docker Image | Version |
|---|---|---|
| User Service | `singhnit/ecommerce-user` | `v1` |
| Product Service | `singhnit/ecommerce-product` | `v1` |
| Cart Service | `singhnit/ecommerce-cart` | `v1` |
| Order Service | `singhnit/ecommerce-order` | `v1` |
| Frontend | `singhnit/ecommerce-frontend` | `v2` |

MongoDB uses `mongo:7`.

## Docker Build

```powershell
docker build -t ecommerce-user:v1 ./backend/user-service
docker build -t ecommerce-product:v1 ./backend/product-service
docker build -t ecommerce-cart:v1 ./backend/cart-service
docker build -t ecommerce-order:v1 ./backend/order-service
docker build -t ecommerce-frontend:v2 ./frontend
```

## Frontend and Nginx

The React frontend is served by Nginx.

API gateways:

```text
/user
/product
/cart
/order
```

Nginx routes these requests to:

```text
/user/    → ecommerce-user:3001
/product/ → ecommerce-product:3002
/cart/    → ecommerce-cart:3003
/order/   → ecommerce-order:3004
```

## AWS Infrastructure

Terraform provisions:

1. VPC
2. Public Subnet
3. Internet Gateway
4. Route Table
5. Route Table Association
6. Security Group
7. EC2 Instance

**AWS Region:** `us-east-1`  
**VPC CIDR:** `10.0.0.0/16`  
**Public Subnet:** `10.0.1.0/24`  
**EC2 Type:** `t3.micro`

## Security Group

| Protocol | Port | Source | Purpose |
|---|---:|---|---|
| TCP | 80 | `0.0.0.0/0` | Public frontend |
| TCP | 22 | `0.0.0.0/0` | SSH administration |
| TCP | 3001-3004 | `10.0.0.0/16` | Backend services |
| All | All | `0.0.0.0/0` | Outbound traffic |

## Terraform Files

```text
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── user-data.sh
└── .terraform.lock.hcl
```

## Terraform Commands

```powershell
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform successfully created **7 AWS resources**.

## EC2 User Data

The EC2 `user-data.sh` automatically:

1. Installs Docker.
2. Starts Docker.
3. Creates `ecommerce-net`.
4. Pulls application images from Docker Hub.
5. Pulls MongoDB.
6. Starts MongoDB.
7. Starts all four backend services.
8. Starts the frontend.

## AWS Deployment Details

**EC2 Instance ID**

```text
i-00b8a6c6ab3d4482a
```

**Public IP**

```text
3.93.40.162
```

**Public DNS**

```text
ec2-3-93-40-162.compute-1.amazonaws.com
```

**Frontend**

```text
http://3.93.40.162
```

## Deployment Verification

The following containers were running on EC2:

```text
ecommerce-frontend
ecommerce-user
ecommerce-product
ecommerce-cart
ecommerce-order
ecommerce-mongodb
```

Docker was successfully installed on EC2.

## Backend Health Checks

All four backend services returned successful health responses:

```text
User Service     → HTTP 200
Product Service  → HTTP 200
Cart Service     → HTTP 200
Order Service    → HTTP 200
```

Health endpoints:

```text
http://localhost:3001/health
http://localhost:3002/health
http://localhost:3003/health
http://localhost:3004/health
```

## Public Application

The deployed application is accessible at:

```text
http://3.93.40.162
```

The frontend is served through Nginx on port 80.

## Screenshot Evidence

The `Screenshots` directory contains evidence for:

- GitHub repository setup
- Application structure
- Dockerfiles
- Docker image builds
- Local container testing
- Docker Hub image tagging and pushing
- Terraform initialization
- Terraform validation
- Terraform plan
- Terraform apply
- AWS EC2 deployment
- SSH connection
- Docker installation
- EC2 Docker containers
- Backend health verification
- Public frontend verification
- Terraform outputs
- AWS networking configuration

## Repository Structure

```text
E-CommerceStore/
├── backend/
│   ├── user-service/
│   │   └── Dockerfile
│   ├── product-service/
│   │   └── Dockerfile
│   ├── cart-service/
│   │   └── Dockerfile
│   └── order-service/
│       └── Dockerfile
├── frontend/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── src/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   ├── user-data.sh
│   └── .terraform.lock.hcl
├── Screenshots/
├── .gitignore
└── README.md
```

## Security

Sensitive files are excluded from Git:

```text
*.pem
*.tfstate
*.tfstate.*
.terraform/
```

The EC2 private key and Terraform state files must not be uploaded to a public GitHub repository.

## Project Objectives Completed

- [x] Dockerized five application services
- [x] Built Docker images locally
- [x] Tested containers locally
- [x] Pushed application images to Docker Hub
- [x] Created AWS VPC
- [x] Created public subnet
- [x] Configured Internet Gateway
- [x] Configured route table
- [x] Configured Security Group
- [x] Created EC2 instance using Terraform
- [x] Installed Docker using EC2 user-data
- [x] Pulled Docker images automatically
- [x] Started application containers
- [x] Verified backend health endpoints
- [x] Deployed frontend using Nginx
- [x] Verified public application access
- [x] Captured deployment evidence

## Learning Outcomes

This project demonstrates practical experience with:

- Docker containerization
- Docker networking
- Microservice architecture
- Docker Hub
- React application deployment
- Nginx reverse proxy
- AWS EC2
- AWS VPC networking
- AWS Security Groups
- Terraform Infrastructure as Code
- Terraform variables and outputs
- EC2 user-data automation
- Cloud deployment troubleshooting
- Application health verification

## Project Information

**Project:** Multi-Service Node.js E-Commerce Application  
**Deployment:** Docker + Terraform + AWS EC2  
**AWS Region:** `us-east-1`  
**Frontend URL:** `http://3.93.40.162`  
**Repository Owner:** `NitinSingh-ops`

## Conclusion

The multi-service Node.js E-Commerce application was successfully containerized using Docker, published to Docker Hub, and deployed to AWS EC2 using Terraform.

The infrastructure and application deployment were verified through Docker container status, backend health checks, Terraform outputs, and public frontend access.
