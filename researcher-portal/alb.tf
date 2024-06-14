
resource "random_integer" "listener_priority" {
  min = 10000
  max = 19999
}

resource "aws_lb_listener_rule" "researcher_subdomain" {
  listener_arn = data.terraform_remote_state.shared.outputs.aws_lb_listener_HTTPS_arn // single HTTPS listener for all subdomains
  priority     = random_integer.listener_priority.result                              // lower values get evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.researcher_portal.arn
  }

  condition {
    host_header {
      values = ["${var.subdomain}.deliberation-lab.org"]
    }
  }
}

resource "aws_lb_target_group" "researcher_portal" {
  name_prefix = "portal"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.shared.outputs.aws_vpc_shared_vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
  lifecycle {
    create_before_destroy = true
  }
}