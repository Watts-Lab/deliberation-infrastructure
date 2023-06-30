
data "aws_route53_zone" "selected" {
  name = "deliberation-lab.org"
}

resource "aws_route53_record" "assets" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "assets"
  type    = "A"
  alias {
    name                   = aws_s3_bucket.deliberation-assets-bucket.domain_name
    zone_id                = aws_s3_bucket.deliberation-assets-bucket.hosted_zone_id
    evaluate_target_health = true
  }
}