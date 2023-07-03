
data "aws_route53_zone" "selected" {
  name = "deliberation-lab.org"
}

resource "aws_route53_record" "assets" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.bucket_name
  type    = "A"
  alias {
    name                   = aws_s3_bucket_website_configuration.deliberation-assets.website_domain
    zone_id                = aws_s3_bucket.deliberation-assets.hosted_zone_id
    evaluate_target_health = true
  }
}