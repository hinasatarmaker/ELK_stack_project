resource "aws_security_group" "kibana_sg" {
  name        = "kibana_sg"
  description = "Allow connection for kibana inbound traffic"
  vpc_id      = aws_vpc.elk_vpc.id

  ingress {
    description      = "Allow port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description = "ingress rules"
    from_port = 5601
    to_port = 5601
    protocol = "tcp"
    cidr_blocks = [ "192.168.2.184/32" ]
   
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

resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion-host-sg"
  description = "Allow connection for Bastion Host"
  vpc_id      = aws_vpc.elk_vpc.id

  ingress {
    description      = "Allow port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["106.213.109.28/32"]
  }
  
  #  ingress {
  #    description      = "Allow port 22"
  #    from_port        = 80
  #    to_port          = 80
  #    protocol         = "tcp"
  #    cidr_blocks      = ["0.0.0.0/0"]
  #  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion-host-sg"
  }
}


resource "aws_security_group" "elasticsearch_sg" {
  vpc_id = aws_vpc.elk_vpc.id
  
  ingress {
    description      = "Allow port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description = "ingress rules"
    from_port = 9200
    to_port = 9200
    protocol = "tcp"
    cidr_blocks = [ "192.168.2.21/32" ]
  }
  ingress {
    description = "ingress rules"
    from_port = 9200
    to_port = 9200
    protocol = "tcp"
    cidr_blocks = [ "46.137.101.160/32" ]
  }
  egress {
    description = "egress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  tags={
    Name="elasticsearch_sg"
  }
}


resource "aws_security_group" "logstash_sg" {
  vpc_id = aws_vpc.elk_vpc.id
  
  ingress {
    description      = "Allow port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description = "ingress rules"
    from_port = 5044
    to_port = 5044
    protocol = "tcp"
    cidr_blocks = [ "192.168.2.184/32" ]
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    description = "egress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  tags={
    Name="logstash_sg"
  }
}

resource "aws_security_group" "packer_sg" {
  vpc_id = aws_vpc.elk_vpc.id
  ingress {
    description = "ingress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  egress {
    description = "egress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  tags={
    Name="packer_sg"
  }
}

resource "aws_security_group" "demo_sg" {
  vpc_id = aws_vpc.elk_vpc.id
  ingress {
    description = "ingress rules"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # cidr_blocks = [ "18.203.195.175/32" ]
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "ingress rules"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # security_groups = [aws_security_group.packer_sg]
    cidr_blocks = [ "18.203.195.175/32" ]
    # cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    description = "egress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  tags={
    Name="demo_sg"
  }
}