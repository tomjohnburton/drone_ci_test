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
