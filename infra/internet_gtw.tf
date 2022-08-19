resource "aws_internet_gateway" "it_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" = "${var.project}-igw"
  }
  depends_on = [
    aws_vpc.my_vpc
  ]
}
