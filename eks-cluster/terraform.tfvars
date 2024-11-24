region           = "us-east-1"
vpc_cidr_block   = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
instance_type    = "t2.medium"
ssh_public_key   = file("~/.ssh/badhrakali-key.pub")
desired_capacity = 2
max_capacity     = 4
min_capacity     = 1
