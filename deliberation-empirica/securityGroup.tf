resource "aws_security_group" "efs_sg" {
  name        = "${var.app_name}-efs-sg"
  description = "${var.app_name} EFS security group"
  vpc_id      = data.terraform_remote_state.shared.outputs.aws_vpc_project_vpc_id

  ingress {
    description     = "Allow only from fargate service"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.shared.outputs.aws_security_group_app_ecs_task_sg_id]
  }

  # Only ingress rules added
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "app_ecs_task_sg" {
  name   = "${var.app_name}_ecs_task_sg"
  vpc_id = data.terraform_remote_state.shared.outputs.aws_vpc.project_vpc.id
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
    security_groups = ["${data.terraform_remote_state.shared.outputs.aws_security_group.app_alb_sg.id}"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    description = "Outbound access from ECS tasks to SSM service"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}