
data "aws_route53_zone" "selected" {
  name = "deliberation-lab.org"
}

resource "aws_route53_record" "assets" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "assets"
  type    = "A"
  alias {
    name                   = "http://${var.bucket_name}.s3-website-${var.region}.amazonaws.com/"
    zone_id                = aws_s3_bucket.deliberation-assets.hosted_zone_id
    evaluate_target_health = true
  }
}