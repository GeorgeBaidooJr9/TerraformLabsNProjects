
output "public-subnet-1" {
  value = aws_subnet.public-subnet-1.id
}

output "public-subnet-2" {
  value = aws_subnet.public-subnet-2.id
}

output "vpc_id" {
    value = aws_vpc.vpc.id
}