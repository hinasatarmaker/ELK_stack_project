resource "aws_security_group" "kibana_sg" {
  name        = "kibana_sg"
  description = "Allow connection for kibana inbound traffic"
  vpc_id      = aws_vpc.elk_vpc.id

#   ingress {
#     description      = "Allow port 80"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["182.70.66.117/32"]
#   }
  ingress {
    description      = "Allow port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["182.70.66.117/32"]
  }
  ingress {
    description = "ingress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 5601
    protocol = "tcp"
    to_port = 5601
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "kibana_sg"
  }
}
