resource "aws_vpc" "badhrakali" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "badhrakali-vpc"
  }
}

resource "aws_subnet" "badhrakali_subnet" {
  count = length(var.availability_zones)
  vpc_id                  = aws_vpc.badhrakali.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "badhrakali-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "badhrakali_igw" {
  vpc_id = aws_vpc.badhrakali.id

  tags = {
    Name = "badhrakali-igw"
  }
}

resource "aws_route_table" "badhrakali_route_table" {
  vpc_id = aws_vpc.badhrakali.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.badhrakali_igw.id
  }

  tags = {
    Name = "badhrakali-route-table"
  }
}

resource "aws_route_table_association" "badhrakali" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.badhrakali_subnet[count.index].id
  route_table_id = aws_route_table.badhrakali_route_table.id
}

resource "aws_security_group" "badhrakali_cluster_sg" {
  vpc_id = aws_vpc.badhrakali.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "badhrakali-cluster-sg"
  }
}

resource "aws_security_group" "badhrakali_node_sg" {
  vpc_id = aws_vpc.badhrakali.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "badhrakali-node-sg"
  }
}

resource "aws_eks_cluster" "badhrakali" {
  name     = "badhrakali-cluster"
  role_arn = aws_iam_role.badhrakali_cluster_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.badhrakali_subnet[*].id
    security_group_ids = [aws_security_group.badhrakali_cluster_sg.id]
  }

  tags = {
    Name = "badhrakali-cluster"
  }
}

resource "aws_eks_node_group" "badhrakali" {
  cluster_name    = aws_eks_cluster.badhrakali.name
  node_group_name = "badhrakali-node-group"
  node_role_arn   = aws_iam_role.badhrakali_node_group_role.arn
  subnet_ids      = aws_subnet.badhrakali_subnet[*].id

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = [var.instance_type]

  remote_access {
    ec2_ssh_key = var.ssh_public_key
    source_security_group_ids = [aws_security_group.badhrakali_node_sg.id]
  }

  tags = {
    Name = "badhrakali-node-group"
  }
}

