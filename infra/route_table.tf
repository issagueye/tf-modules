resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.it_gw.id
  }

  tags = {
    Name = "${var.project}-Default-rt"
  }
  lifecycle {
    create_before_destroy = false
  }
  depends_on = [
    aws_internet_gateway.it_gw
  ]
}

resource "aws_route_table_association" "internet_access" {
  count = var.availability_zones_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.main-rt.id
  lifecycle {
    create_before_destroy = false
  }
  depends_on = [
    aws_route_table.main-rt
  ]
}