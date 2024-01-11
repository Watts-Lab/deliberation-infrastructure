

// we will have multiple studies each with their own subdomain, but they will
// all be hosted on the same load balancer, and each will have its own target 
// group. 
// These are separated into different terraform workspaces, so we can use a generic name
// for each service within the workspace

resource "random_integer" "empirica_priority" {
  min = 9000
  max = 9999
}

resource "aws_lb_listener_rule" "study_subdomain" {
  listener_arn = data.terraform_remote_state.shared.outputs.aws_lb_listener_HTTPS_arn // single HTTPS listener for all subdomains
  priority     = random_integer.empirica_priority.result                                                                  // lower values get evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.empirica.arn
  }

  condition {
    host_header {
      values = ["${var.subdomain}.deliberation-lab.org"]
    }
  }
}

resource "aws_lb_target_group" "empirica" {
  name_prefix = "study"
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


resource "random_integer" "etherpad_priority" {
  min = 8000
  max = 8999
}
resource "aws_lb_listener_rule" "study_subdomain_etherpad_forward" {
  listener_arn = data.terraform_remote_state.shared.outputs.aws_lb_listener_HTTPS_arn
  priority     = 90 // lower values get evaluated first

  action {
    type             = "forward"
    target_group_arn = data.terraform_remote_state.shared.outputs.aws_lb_target_group_etherpad_arn
  }

  condition {
    host_header {
      values = ["${var.subdomain}.deliberation-lab.org"]
    }
  }

  condition { // all conditions must be met
    path_pattern {
      values = ["/etherpad*"]
    }
  }

}