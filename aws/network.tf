# dev vpc
resource "aws_vpc" "devbarogo-vpc" {
  cidr_block = "10.10.10.0/24"
  tags = {
    Name = "devbarogo-vpc-private"
  }
}

# dev subnet
resource "aws_subnet" "devbarogo-subnet-c" {
  vpc_id = "${aws_vpc.devbarogo-vpc.id}"
  cidr_block = "10.10.10.128/25"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = false
  tags = {
    Name = "devbarogo-subnet-private"
  }
}

# stage vpc
resource "aws_vpc" "stagebarogo-vpc" {
  cidr_block = "10.10.20.0/24"
  tags = {
    Name = "stagebarogo-vpc-private"
  }
}

# stage subnet
resource "aws_subnet" "stagebarogo-subnet-c" {
  vpc_id = "${aws_vpc.stagebarogo-vpc.id}"
  cidr_block = "10.10.20.128/25"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = false
  tags = {
    Name = "stagebarogo-subnet-private"
  }
}

# data vpc
resource "aws_vpc" "databarogo-vpc" {
  cidr_block = "10.10.30.0/24"
  tags = {
    Name = "databarogo-vpc-private"
  }
}

# data subnet
resource "aws_subnet" "databarogo-subnet-c" {
  vpc_id = "${aws_vpc.databarogo-vpc.id}"
  cidr_block = "10.10.30.128/25"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = false
  tags = {
    Name = "databarogo-subnet-private"
  }
}

# pro vpc
resource "aws_vpc" "probarogo-vpc" {
  cidr_block = "10.10.40.0/24"
  tags = {
    Name = "probarogo-vpc-public"
  }
}

# pro subnet
resource "aws_subnet" "probarogo-subnet-c" {
  vpc_id = "${aws_vpc.probarogo-vpc.id}"
  cidr_block = "10.10.40.128/25"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "probarogo-subnet-public"
  }
}



# dev 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.devbarogo-vpc.id
    tags = { Name = "devbarogo"}
}

# dev NAT 게이트웨이가 사용할 Elastic IP생성
resource "aws_eip" "devnateip" {
  vpc      = true
}

# dev NAT 게이트웨이 생성
resource "aws_nat_gateway" "dev-natgw" {
  allocation_id = aws_eip.devnateip.id
  subnet_id      = aws_subnet.devbarogo-subnet-c.id
  tags = {
         Name = "dev-natgw"
  }
}

# stage 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "stage-igw" {
    vpc_id = aws_vpc.stagebarogo-vpc.id
    tags = { Name = "stagebarogo"}
}

# stage NAT 게이트웨이가 사용할 Elastic IP생성
resource "aws_eip" "stagenateip" {
  vpc      = true
}

# stage NAT 게이트웨이 생성
resource "aws_nat_gateway" "stage-natgw" {
  allocation_id = aws_eip.stagenateip.id
  subnet_id      = aws_subnet.stagebarogo-subnet-c.id
  tags = {
         Name = "stage-natgw"
  }
}

# data 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "data-igw" {
    vpc_id = aws_vpc.databarogo-vpc.id
    tags = { Name = "databarogo"}
}

# data NAT 게이트웨이가 사용할 Elastic IP생성
resource "aws_eip" "datanateip" {
  vpc      = true
}

# data NAT 게이트웨이 생성
resource "aws_nat_gateway" "data-natgw" {
  allocation_id = aws_eip.datanateip.id
  subnet_id      = aws_subnet.databarogo-subnet-c.id
  tags = {
         Name = "data-natgw"
  }
}

# pro 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "pro-igw" {
    vpc_id = aws_vpc.probarogo-vpc.id
    tags = { Name = "probarogo"}
}

# pro NAT 게이트웨이가 사용할 Elastic IP생성
resource "aws_eip" "pronateip" {
  vpc      = true
}

# pro NAT 게이트웨이 생성
resource "aws_nat_gateway" "pro-natgw" {
  allocation_id = aws_eip.pronateip.id
  subnet_id      = aws_subnet.probarogo-subnet-c.id
  tags = {
         Name = "pro-natgw"
  }
}

# dev 라우팅
resource "aws_route_table" "dev-private-route" {
  vpc_id = aws_vpc.devbarogo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.dev-natgw.id
 }
  tags = {
    Name = "dev-private-route"
  }
}

resource "aws_route_table_association" "dev-private-route-a" {
  subnet_id      = aws_subnet.devbarogo-subnet-c.id
  route_table_id = aws_route_table.dev-private-route.id
}

# data 라우팅
resource "aws_route_table" "data-private-route" {
  vpc_id = aws_vpc.databarogo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.data-natgw.id
 }
  tags = {
    Name = "data-private-route"
  }
}

resource "aws_route_table_association" "data-private-route-a" {
  subnet_id      = aws_subnet.databarogo-subnet-c.id
  route_table_id = aws_route_table.data-private-route.id
}

# 스테이지 라우팅
resource "aws_route_table" "stage-private-route" {
  vpc_id = aws_vpc.stagebarogo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.stage-natgw.id
 }
  tags = {
    Name = "stage-private-route"
  }
}

resource "aws_route_table_association" "stage-private-route-a" {
  subnet_id      = aws_subnet.stagebarogo-subnet-c.id
  route_table_id = aws_route_table.stage-private-route.id
}

# 프로덕션 라우팅
resource "aws_route_table" "pro-private-route" {
  vpc_id = aws_vpc.probarogo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.pro-natgw.id
 }
  tags = {
    Name = "pro-private-route"
  }
}

resource "aws_route_table_association" "pro-private-route-a" {
  subnet_id      = aws_subnet.probarogo-subnet-c.id
  route_table_id = aws_route_table.pro-private-route.id
}

## 보안그룹
# resource.tf
resource "aws_security_group" "barogo_web" {
  vpc_id = "{aws_vpc.probarogo-vpc.id}"

  name = "vpc_test_web"
  description = "Allow incoming HTTP connections & SSH access"

# node.js server
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# vue.js server
  ingress {
    from_port = 3030
    to_port = 3030
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# TLS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # 개발자 접근
    cidr_blocks = ["112.223.14.90/32"]
  }

  tags = {
    Name = "barogo_web"
  }
}

resource "aws_instance" "wb" {
  ami = "ami-0a93a08544874b3b7"
  instance_type = "t3.micro"
  key_name = "mykey"
  subnet_id = "${aws_subnet.probarogo-subnet-c.id}"
  vpc_security_group_ids = ["${aws_security_group.barogo_web.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags = {
    Name = "wb"
  }
}
