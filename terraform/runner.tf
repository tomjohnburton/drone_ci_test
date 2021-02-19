resource "aws_instance" "runner" {
  depends_on = [
    aws_instance.drone]

  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  security_groups = [
    aws_security_group.runner.name]

  key_name = aws_key_pair.local.key_name

  connection {
    type = "ssh"
    user = "ubuntu"
    host = aws_instance.drone.public_ip
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source = "../scripts/docker.sh"
    destination = "/tmp/docker.sh"
  }
  provisioner "file" {
    source = "../scripts/runner.sh"
    destination = "/tmp/runner.sh"
  }
  provisioner "file" {
    source = "../secrets"
    destination = "/tmp/secrets"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker.sh",
      "chmod +x /tmp/runner.sh",
      "/tmp/docker.sh",
      "/tmp/runner.sh",
    ]
  }
}

