# share a single alb across services because its cheaper

resource "aws_lb" "shared_alb" {
  name                       = "shared-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.shared_alb.id]
  subnets                    = [aws_subnet.public1.id, aws_subnet.public2.id]
  enable_deletion_protection = false
}

// Listen for HTTP traffic on port 80 and redirect to HTTPS
resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.shared_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

// Listen for HTTPS traffic on port 443
// below we add rules to forward to target group based on subdomain
resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.shared_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  // todo: redirect to deliberation-lab.org if subdomain is not found in rules
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No content found at this address"
      status_code  = "404"
    }

  }
}

resource "aws_lb_listener_rule" "subdomain_study" {
  listener_arn = aws_lb_listener.HTTPS.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.study.arn
  }

  condition {
    host_header {
      values = ["study.deliberation-lab.org*"]
    }
  }

}

resource "aws_lb_listener_rule" "subdomain_scheduler" {
  listener_arn = aws_lb_listener.HTTPS.arn
  priority     = 200 // lower values get evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scheduler.arn
  }

  condition {
    host_header {
      values = ["scheduler.deliberation-lab.org"]
    }
  }
}

// Todo: add rules for researcher subdomain

// Containers will attach to their respective target groups
resource "aws_lb_target_group" "study" {
  name        = "study-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.shared_vpc.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_target_group" "scheduler" {
  name        = "scheduler-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.shared_vpc.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
}

resource "aws_security_group" "shared_alb" {
  name   = "shared-alb-sg"
  vpc_id = aws_vpc.shared_vpc.id
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}