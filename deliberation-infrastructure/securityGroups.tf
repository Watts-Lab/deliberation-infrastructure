// defines security groups for services that have their own terraform workspaces, including:
// 1. study service
// 2. scheduling service
// 3. video coding service

// This means that outputs from the top level / shared workspace can be imported
// into the other services, but we don't need to know about those services here.

resource "aws_security_group" "ecs_service_study" {
  // can be reused by all instances of the study service in the region
  name   = "ecs_service_study_sg_${var.environment}"
  vpc_id = aws_vpc.shared_vpc.id
  ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.app_alb_sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    description = "Outbound access from ECS tasks to SSM service" // do we need this? is this description correct? is it redundant with the above rule?
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}