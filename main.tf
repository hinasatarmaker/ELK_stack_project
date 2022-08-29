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
  ami           = var.kibana_ami_id
  instance_type = "t3.micro"

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

resource "aws_instance" "es_instance" {
  ami           = var.elasticsearch_ami_id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.elasticsearch_sg.id]
  key_name = "talent-academy-lab"
  subnet_id = aws_subnet.private.id

  tags = {
    Name = "es_instance"
  }
}

resource "aws_instance" "logstash_instance" {
  ami           = var.logstash_ami_id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.logstash_sg.id]
  key_name = "talent-academy-lab"
  subnet_id = aws_subnet.private.id

  tags = {
    Name = "logstash_instance"
  }
}

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]

  key_name = "talent-academy-lab"
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "Bastion-Host"
  }
}

resource "aws_eip" "bastion_host_ip" {
  instance = aws_instance.bastion_host.id
  vpc = true
}

resource "aws_instance" "demo1" {
  # ami           = data.aws_ami.ubuntu.id
  ami           = var.beats_ami_id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  key_name = "talent-academy-lab"
  subnet_id = aws_subnet.data1.id

  tags = {
    Name = "demo1-ec2"
  }
}

# resource "aws_instance" "demo2" {
#   # ami           = data.aws_ami.ubuntu.id
#   ami           = var.beats_ami_id
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [aws_security_group.demo_sg.id]
#   key_name = "talent-academy-lab"
#   subnet_id = aws_subnet.data2.id

#   tags = {
#     Name = "demo2-ec2"
#   }
# }

# resource "aws_instance" "demo3" {
#   # ami           = data.aws_ami.ubuntu.id
#   ami           = var.beats_ami_id
#   instance_type = "t2.micro"

#   vpc_security_group_ids = [aws_security_group.demo_sg.id]
#   key_name = "talent-academy-lab"
#   subnet_id = aws_subnet.data3.id

#   tags = {
#     Name = "demo3-ec2"
#   }
# }