resource "aws_route53_record" "study_subdomain" {
  name    = "${var.subdomain}.deliberation-lab.org"
  zone_id = data.terraform_remote_state.shared.outputs.aws_route53_zone_apex_zone_id
  type    = "A"
  alias {
    name                   = data.terraform_remote_state.shared.outputs.aws_lb_shared_alb_dns_name
    zone_id                = data.terraform_remote_state.shared.outputs.aws_lb_shared_alb_zone_id
    evaluate_target_health = true
  }
}