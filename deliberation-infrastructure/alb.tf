# each resource describes at least one infrastructure object
# syntax: resource type localName - name is only used in this module's scope
# config settings within each block is dependent on the resource type

resource "aws_lb" "app_alb" {
  name                       = "${var.app_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.app_alb_sg.id]
  subnets                    = [aws_subnet.public1.id, aws_subnet.public2.id]
  enable_deletion_protection = false
}
resource "aws_lb_target_group" "app_alb_target_group" {
  name        = "${var.app_name}-target-group"
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
/* resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.id
  port              = 3000
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  default_action {
    target_group_arn = aws_alb_target_group.app_alb_target_group.arn
    type             = "forward"
  }
} */

resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.app_alb.arn
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

resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  }
}

resource "aws_security_group" "app_alb_sg" {
  name   = "${var.security_group_name}_alb_sg"
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