resource "aws_subnet" "public" {
#   vpc_id     = aws_vpc.Lab_vpc.id
  vpc_id     = aws_vpc.elk_vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone  = "eu-west-1a"

  tags = {
    Name = "Kibana Subnet-Public"
  }
}

resource "aws_subnet" "private" {
#   vpc_id     = aws_vpc.Lab_vpc.id
  vpc_id     = aws_vpc.elk_vpc.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "Monitoring Subnet-Private"
  }
}

resource "aws_subnet" "data" {
#   vpc_id     = aws_vpc.Lab_vpc.id
  vpc_id     = aws_vpc.elk_vpc.id
  cidr_block = "192.168.3.0/24"

  tags = {
    Name = "Application Subnet-Private"
  }
}