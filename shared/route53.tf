// the apex record is defined permanently in the asw console
// we just import the value here

data "aws_route53_zone" "apex" {
  name = "deliberation-lab.org"
}

// Define all subdomain records here 
// so we can forward them all to the load balancer

resource "aws_route53_record" "study" {
  name    = "study.deliberation-lab.org"
  zone_id = data.aws_route53_zone.apex.zone_id
  type    = "A"
  alias {
    name                   = aws_lb.shared_alb.dns_name
    zone_id                = aws_lb.shared_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "scheduler" {
  name    = "scheduler.deliberation-lab.org"
  zone_id = data.aws_route53_zone.apex.zone_id
  type    = "A"
  alias {
    name                   = aws_lb.shared_alb.dns_name
    zone_id                = aws_lb.shared_alb.zone_id
    evaluate_target_health = true
  }
}