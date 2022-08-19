locals {
  nat_gateway_count = var.single_nat_gateway && var.enable_nat_gateway == true ? 1 : var.one_nat_gateway_per_az == true ? length(var.azs) : 0
}

resource "aws_eip" "main" {
  count = var.enable_nat_gateway == true ? local.nat_gateway_count : 0
  vpc = true

  tags = {
    Name = "${var.project}-ngw-ip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway == true ? local.nat_gateway_count : 0
  allocation_id = aws_eip.main[count.index].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project}-ngw"
  }
  depends_on = [
    aws_eip.main
  ]
}


resource "aws_route_table" "private-rt" {
  count = var.enable_nat_gateway == true ? local.nat_gateway_count : 0
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  tags = {
    Name = "${var.project}-Private-rt"
  }
  depends_on = [
    aws_internet_gateway.it_gw
  ]

}

resource "aws_route_table_association" "nat_gtw_access" {
  count = var.enable_nat_gateway == true ? local.nat_gateway_count : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rt[count.index].id
  lifecycle {
    create_before_destroy = false
  }
  depends_on = [
    aws_route_table.private-rt
  ]
}

# Add route to route table
resource "aws_route" "main" {
  count = var.enable_nat_gateway == true ? local.nat_gateway_count : 0
  route_table_id         = aws_vpc.my_vpc.main_route_table_id[count.index]
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_nat_gateway.main
  ]
  lifecycle {
    create_before_destroy = false
  }
}