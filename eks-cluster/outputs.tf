output "cluster_id" {
  value = aws_eks_cluster.badhrakali.id
}

output "node_group_id" {
  value = aws_eks_node_group.badhrakali.id
}

output "vpc_id" {
  value = aws_vpc.badhrakali.id
}

output "subnet_ids" {
  value = aws_subnet.badhrakali_subnet[*].id
}
