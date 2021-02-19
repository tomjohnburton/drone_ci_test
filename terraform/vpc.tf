resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "drone" {
  name = "drone"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
resource "aws_security_group" "runner" {
  name = "runner"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      aws_default_vpc.default.cidr_block]
  }
}
