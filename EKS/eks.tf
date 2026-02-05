# Security group for EKS cluster's control-plane endpoint (and node group)
resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-sg"
  vpc_id = aws_vpc.eks_vpc.id

  # allow all traffic inside SG
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
    description     = "Allow all within cluster SG"
  }

  # Allow worker nodes to access the internet (egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    endpoint_public_access = true
    # endpoint_private_access = false
  }

  # minimal logging to reduce complexity
  enabled_cluster_log_types = []
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]

  tags = {
    Name = var.cluster_name
  }
}

# EKS managed node group
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.public[*].id
  scaling_config {
    desired_size = var.node_desired_capacity
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  ami_type       = var.ami_type
  instance_types = [var.node_instance_type]

  capacity_type = var.capacity_type

  tags = {
    Name = "${var.cluster_name}-node"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-ECRReadOnly,
    aws_eks_cluster.this
  ]
}
