resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "allow_all_ingress" {
  network_acl_id = aws_network_acl.main.id

  rule_number = 100
  egress      = false
  protocol    = "-1"
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
}

resource "aws_network_acl_rule" "allow_all_egress" {
  network_acl_id = aws_network_acl.main.id

  rule_number = 100
  egress      = true
  protocol    = "-1"
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
}

resource "aws_network_acl_association" "public" {
  count = var.availability_zones_count

  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_network_acl_association" "private" {
  count = var.availability_zones_count

  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.private[count.index].id
}
