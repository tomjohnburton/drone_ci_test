resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "drone_key" {
  key_name = var.key_name
  public_key = tls_private_key.tls.public_key_openssh
}
