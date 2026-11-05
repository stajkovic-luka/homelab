output "vpc_id" {
    description = "VPC_ID"
    value = aws_vpc.main.id
}

output "private_subnet_ids" {
    description = "Private Subnet IDs"
    value = aws_subnet.private[*].id
}

output "public_subnets_ids" {
    description = "Public Subnet IDs"
    value = aws_subnet.public[*].id
}
