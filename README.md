# Terraform EKS Module

A reusable Terraform module to provision a public and scalable Amazon EKS cluster with required IAM roles (for cluster and nodes), managed node groups, networking configuration, and core Kubernetes addons.

---

## Prerequisites

Before using this module, ensure the following are installed:

* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* Configured AWS credentials to authenticate terraform with AWS using command - `aws configure`
* kubectl (optional, for cluster access)

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/NashTech-Labs/EKS_Terraform_Module.git
```

### 2. Navigate to the EKS module directory

```bash
cd EKS
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the execution plan

```bash
terraform plan
```

### 5. Apply the configuration

```bash
terraform apply
```

Type `yes` when prompted to create the infrastructure.

---

## Infrastructure Created

This module provisions:

* IAM roles and policies required for EKS cluster and nodes
* Amazon EKS cluster
* Managed node group
* VPC networking configuration
* Core EKS addons (VPC CNI, CoreDNS, kube-proxy)

---

## 🔗 Connect to the Cluster

After successful deployment:

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl get nodes
```

---

## Destroy Infrastructure

To remove all created resources:

```bash
terraform destroy
```
