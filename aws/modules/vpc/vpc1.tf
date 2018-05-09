#########Create VPC
resource "aws_vpc" "tfvpcexample" {
       "cidr_block" = "10.0.0.0/16"
  tags {
  Name = "TerraformVPC"
  }
}


############Create Public Subnets
resource "aws_subnet" "Public1" {
  vpc_id     = "${aws_vpc.tfvpcexample.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
   availability_zone = "eu-west-2a"
  tags {
    Name = "Public-AZ1"
  }
}


resource "aws_subnet" "Public2" {
  vpc_id     = "${aws_vpc.tfvpcexample.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
   availability_zone = "eu-west-2b"
  tags {
    Name = "Public-AZ2"
  }
}


############Create Private Subnets

resource "aws_subnet" "Private1" {
  vpc_id     = "${aws_vpc.tfvpcexample.id}"
  cidr_block = "10.0.3.0/24"
   availability_zone = "eu-west-2a"
  tags {
    Name = "Private-AZ1"
  }
}



resource "aws_subnet" "Private2" {
  vpc_id     = "${aws_vpc.tfvpcexample.id}"
  cidr_block = "10.0.4.0/24"
   availability_zone = "eu-west-2b"
  tags {
    Name = "Private-AZ2"
  }
}



############Create IGW
resource "aws_internet_gateway" "teraigw" {
  vpc_id = "${aws_vpc.tfvpcexample.id}"

  tags {
    Name = "TerraformIGW"
  }
}
############Create NAT GW
resource "aws_eip" "nat" {
  vpc = true
  depends_on = ["aws_internet_gateway.teraigw"]
  tags {
     Name = "Nat EIP" }
  }

resource "aws_nat_gateway" "terangw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.Public1.id}"

  tags {
    Name = "TerraformNatGW"
  }

  depends_on = ["aws_internet_gateway.teraigw"]
}


############Create / amend route table 

### Amend default subnet and attach to Private Subnet

resource "aws_route" "ngwr" {
    route_table_id  = "${aws_vpc.tfvpcexample.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.terangw.id}"
}

resource "aws_route_table_association" "priv1a" {
  subnet_id      = "${aws_subnet.Private1.id}"
  route_table_id =  "${aws_vpc.tfvpcexample.main_route_table_id}"
}
resource "aws_route_table_association" "priv2a" {
  subnet_id      = "${aws_subnet.Private2.id}"
  route_table_id =  "${aws_vpc.tfvpcexample.main_route_table_id}"
}

### Create New route table and attach to Public Subnet

resource "aws_route_table" "pub_r" {
  vpc_id = "${aws_vpc.tfvpcexample.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.teraigw.id}"
  }

  tags {
    Name = "pubroute"
  }
}

resource "aws_route_table_association" "pub1a" {
  subnet_id      = "${aws_subnet.Public1.id}"
  route_table_id =  "${aws_route_table.pub_r.id}"
}
resource "aws_route_table_association" "pub2a" {
  subnet_id      = "${aws_subnet.Public2.id}"
  route_table_id =  "${aws_route_table.pub_r.id}"
}


############Create security groups
resource "aws_security_group" "tf_web_servers" {
  name        = "allow_inbound"
  description = "Allow inbound web and ssh traffic"
    vpc_id = "${aws_vpc.tfvpcexample.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
  tags {
    Name = "tf_web_servers"
  }
}
