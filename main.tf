# VPC
resource "aws_vpc" "app-vpc" {
  cidr_block           = "172.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "main"
  }
}

# Public Subnet
resource "aws_subnet" "sn-pub-1a" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "172.168.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Wordpress"
  }
}


# Private subnet
resource "aws_subnet" "sn-pri-1b" {
  vpc_id            = aws_vpc.app-vpc.id
  cidr_block        = "172.168.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "MySql"
  }
}


# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "main"
  }
}


# Elastic Ip
resource "aws_eip" "eip" {
  vpc = true
}


# Nat Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.sn-pub-1a.id
}


# Route table for Private subnet
resource "aws_route_table" "mysql-route" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "mysql-route"
  }
}


#  route table association
resource "aws_route_table_association" "pri-association" {
  subnet_id      = aws_subnet.sn-pri-1b.id
  route_table_id = aws_route_table.mysql-route.id
}


# Route table for Public subnet
resource "aws_route_table" "wp-route" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "wp-route"
  }
}


# Route table association with public
resource "aws_route_table_association" "pub-association" {
  subnet_id      = aws_subnet.sn-pub-1a.id
  route_table_id = aws_route_table.wp-route.id
}



# Security rule for wp
resource "aws_security_group" "wp-sg" {
  name        = "wp-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.app-vpc.id

  ingress {
    description = "For http users"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "For http users"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "For ssh login if needed"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp-sg"
  }
}


# Security rule for mysql
resource "aws_security_group" "mysql-sg" {
  name        = "mysql-sg"
  description = "Allows 3306 port."
  vpc_id      = aws_vpc.app-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow mysql user"
  }
}

# WP Instance Creation
resource "aws_instance" "wp-ins" {
  ami               = "ami-08e4e35cccc6189f4"
  instance_type     = "t2.micro"
  key_name          = var.key_name
  user_data         = file("index.sh")
  availability_zone = "us-east-1a"
  subnet_id         = aws_subnet.sn-pub-1a.id
  security_groups   = ["${aws_security_group.wp-sg.id}"]
  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "Wordpress"
  }
}

# MySQL instance creation
resource "aws_instance" "mysql-ins" {
  ami               = "ami-08e4e35cccc6189f4"
  instance_type     = "t2.micro"
  key_name          = var.key_name
  user_data         = file("mysql.sh")
  availability_zone = "us-east-1b"
  subnet_id         = aws_subnet.sn-pri-1b.id
  private_ip        = "172.168.1.136"
  security_groups   = ["${aws_security_group.mysql-sg.id}"]
  root_block_device {
    volume_size = 10
  }
  
  tags = {
    Name = "MySQL"
  }
}

# # MySQL instance creation
# resource "aws_instance" "mysql-ins2" {
#   ami               = "ami-08e4e35cccc6189f4"
#   instance_type     = "t2.micro"
#   key_name          = var.key_name
#   user_data         = file("mysql.sh")
#   availability_zone = "us-east-1a"
#   subnet_id         = aws_subnet.sn-pub-1a.id
#   security_groups   = ["${aws_security_group.mysql-sg.id}"]
#   root_block_device {
#     volume_size = 10
#   }
#   tags = {
#     Name = "MySQL"
#   }
# }