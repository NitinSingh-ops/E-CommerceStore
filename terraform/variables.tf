variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

variable "dockerhub_username" {
  description = "Docker Hub username"
  type        = string
  default     = "singhnit"
}

variable "docker_tag" {
  description = "Docker image tag for backend services"
  type        = string
  default     = "v1"
}

variable "frontend_tag" {
  description = "Docker image tag for frontend"
  type        = string
  default     = "v2"
}
