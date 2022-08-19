output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.my_vpc.cidr_block
}

output "vpc_name" {
  value = aws_vpc.my_vpc
}

output "vpc_public_subnets" {
  value = {
    for subnet in aws_subnet.public :
    subnet.id => subnet.cidr_block
  }
}

output "vpc_private_subnets" {
  value = {
    for subnet in aws_subnet.private :
    subnet.id => subnet.cidr_block
  }
}