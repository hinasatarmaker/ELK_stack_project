resource "aws_vpc" "elk_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "elk_vpc"
}
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

   owners = ["099720109477"] # Canonical
}

resource "aws_instance" "kibana_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "m4.large"

  vpc_security_group_ids = [aws_security_group.kibana_sg.id]
  key_name = "talent-academy-lab"
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "kibana_instance"
  }
}

resource "aws_eip" "kibana_eip" {
  instance = aws_instance.kibana_instance.id
  vpc = true
}
