variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "tf-eks-no-mod"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33"
}

variable "node_instance_type" {
  description = "Instance type for worker nodes"
  type        = string
  default     = "t3.micro"
}

variable "node_desired_capacity" {
  description = "Desired worker nodes"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Min worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Max worker nodes"
  type        = number
  default     = 1
}

variable "cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ami_type" {
  description = "Node AMI type"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "capacity_type" {
  description = "Node capacity type"
  type        = string
  default     = "ON_DEMAND"
}


