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

# Add route to route table
resource "aws_route" "main" {
  count = var.enable_nat_gateway == true ? local.nat_gateway_count : 0
  route_table_id         = aws_vpc.this.default_route_table_id
  nat_gateway_id         = aws_nat_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_nat_gateway.main
  ]
}