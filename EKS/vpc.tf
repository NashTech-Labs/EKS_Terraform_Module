data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# Create two public subnets (spread across AZs)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(var.cidr, 8, count.index + 1) # simple split
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-${count.index + 1}"
  }
}

# Public route table and association
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
