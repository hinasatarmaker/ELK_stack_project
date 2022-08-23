resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.elk_vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone  = "eu-west-1a"

  tags = {
    Name = "Kibana Subnet-Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.elk_vpc.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "Monitoring Subnet-Private"
  }
}

resource "aws_subnet" "data1" {
  vpc_id     = aws_vpc.elk_vpc.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "eu-west1a"

  tags = {
    Name = "Application Subnet-Private1"
  }
}

resource "aws_subnet" "data2" {
  vpc_id     = aws_vpc.elk_vpc.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "eu-west1b"
  tags = {
    Name = "Application Subnet-Private2"
  }
}

resource "aws_subnet" "data3" {
  vpc_id     = aws_vpc.elk_vpc.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "eu-west1c"
  tags = {
    Name = "Application Subnet-Private3"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.elk_vpc.id

  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_eip" "nat_eip" {
#   instance = aws_instance.web.id
  vpc      = true
}

resource "aws_route_table" "IG_route_table" {
  vpc_id = aws_vpc.elk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "IG_route_table"
  }
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.elk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "nat_route_table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.IG_route_table.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.nat_route_table.id
}

resource "aws_route_table_association" "data1" {
  subnet_id      = aws_subnet.data1.id
  route_table_id = aws_route_table.nat_route_table.id
}

resource "aws_route_table_association" "data2" {
  subnet_id      = aws_subnet.data2.id
  route_table_id = aws_route_table.nat_route_table.id
}

resource "aws_route_table_association" "data3" {
  subnet_id      = aws_subnet.data3.id
  route_table_id = aws_route_table.nat_route_table.id
}