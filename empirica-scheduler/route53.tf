
data "aws_route53_zone" "selected" {
  name = "deliberation-lab.org"
}

/* resource "aws_route53_record" "study" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "study"
  type    = "A"
  ttl     = 300
  records = [aws_lb.app_alb.dns_name]
} */

resource "aws_route53_record" "scheduler" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "scheduler"
  type    = "A"
  alias {
    name                   = data.terraform_remote_state.shared.outputs.aws_lb_app_alb_dns_name
    zone_id                = data.terraform_remote_state.shared.outputs.aws_lb_app_alb_zone_id
    evaluate_target_health = true
  }
}