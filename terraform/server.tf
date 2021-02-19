resource "aws_instance" "drone" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  security_groups = [
    aws_security_group.drone.name]

  key_name = aws_key_pair.drone_key.key_name

  connection {
    type = "ssh"
    user = "ubuntu"
    host = aws_instance.drone.public_ip
    private_key = tls_private_key.tls.private_key_pem
  }

  provisioner "file" {
    source = "../scripts/docker.sh"
    destination = "/tmp/docker.sh"
  }
  provisioner "file" {
    source = "../scripts/server.sh"
    destination = "/tmp/server.sh"
  }
  provisioner "file" {
    source = "../secrets"
    destination = "/tmp/secrets"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker.sh",
      "chmod +x /tmp/server.sh",
      "/tmp/docker.sh",
      "/tmp/server.sh",
    ]
  }
}

