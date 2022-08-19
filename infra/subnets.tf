
locals {
  availability_zones_count = length(var.azs)
}
# Public Subnets
resource "aws_subnet" "public" {
  count = local.availability_zones_count

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index)
 //availability_zone = data.aws_availability_zones.available.names[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project}-public-subnet"
  }

  map_public_ip_on_launch = true
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_subnet" "private" {
  count = local.availability_zones_count

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index + local.availability_zones_count)
  availability_zone = var.azs[count.index]
 // availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project}-private-subnet"
  }

  lifecycle {
    create_before_destroy = false
  }

}