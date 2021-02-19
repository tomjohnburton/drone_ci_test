provider "aws" {
  region = "eu-central-1"
  profile = "tomourbrain"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "099720109477"]
  # Canonical
}

data "aws_route53_zone" "ourbrain-io" {
  name = "ourbrain.io"
}

resource "aws_route53_record" "drone" {
  name = "drone.ourbrain.io"
  type = "A"
  ttl = "300"
  zone_id = data.aws_route53_zone.ourbrain-io.id
  records = [
    aws_instance.drone.public_ip
  ]
}

resource "aws_key_pair" "local" {
  key_name = "local"
  public_key = file("~/.ssh/id_rsa.pub")
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

resource "aws_instance" "drone" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  security_groups = [
    aws_security_group.drone.name]

  key_name = aws_key_pair.local.key_name

  connection {
    type = "ssh"
    user = "ubuntu"
    host = aws_instance.drone.public_ip
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source = "./provision.sh"
    destination = "/tmp/provision.sh"
  }

  provisioner "file" {
    source = "./secrets"
    destination = "/tmp/secrets"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision.sh",
      "/tmp/provision.sh",
    ]
  }
}
