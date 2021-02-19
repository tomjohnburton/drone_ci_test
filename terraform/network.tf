data "aws_route53_zone" "zone" {
  name = var.zone_name
}

resource "aws_route53_record" "drone" {
  name = var.drone_server_url
  type = "A"
  ttl = "300"
  zone_id = data.aws_route53_zone.zone.id
  records = [
    aws_instance.drone.public_ip
  ]
}
