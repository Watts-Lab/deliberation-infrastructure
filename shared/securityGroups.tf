// Shared security group for services that need to connect to the shared alb
// and to the efs. 

// including:
// 1. study service
// 2. scheduling service
// 3. video coding service

// This means that outputs from the top level / shared workspace can be imported
// into the other services, but we don't need to know about those services here.

resource "aws_security_group" "ecs_services" {
  // can be reused by all instances of the study service in the region
  name   = "ecs_services_sg"
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
    security_groups = [aws_security_group.shared_alb.id]
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
