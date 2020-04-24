# resource.tf
resource "aws_security_group" "barogo_web" {
  vpc_id = "default

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
    cidr_blocks = ["10.10.10.0/24"]
  }

  tags = {
    Name = "barogo_web"
  }
}
