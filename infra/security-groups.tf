resource "aws_security_group" "public-sg" {
  name = "${var.project}-Public-sg"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project}-Public-sg"
  }
}

resource "aws_security_group" "private-sg" {
  name = "${var.project}-Private-sg"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project}-Private-sg"
  }
}

# -------- RULES ----------------------

locals {
    public_inbound_ports = var.public_inbound_ports
    private_inbound_ports = var.private_inbound_ports
}

resource "aws_security_group_rule" "sg_public" {
  security_group_id = aws_security_group.public-sg.id
  for_each = local.public_inbound_ports
  type = "ingress"
  from_port = each.value
  to_port = each.value
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "sg_private" {
  security_group_id = aws_security_group.private-sg.id
  for_each = local.private_inbound_ports
  type = "ingress"
  from_port = each.value
  to_port = each.value
  protocol = "tcp"
  source_security_group_id = aws_security_group.public-sg.id
}
