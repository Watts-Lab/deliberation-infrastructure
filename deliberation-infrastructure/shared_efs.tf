// define an EFS file system
//
// This will be mounted by:
// 1. one or more study services
// 2. the scheduling service
// 3. the video coding service
//
// Each of these services will read and append to files in the EFS volume
//
// In addition, it will be backed up to S3 by datasync

resource "aws_efs_file_system" "shared_efs" {
  creation_token = "shared_efs_${var.region}"
  tags = {
    Name = "shared_efs_${var.region}"
  }
  encrypted = true
}

resource "aws_efs_mount_target" "shared_efs_mount_target" {
  file_system_id  = aws_efs_file_system.shared_efs.id
  subnet_id       = aws_subnet.public1.id # EFS mount target must be in at least one availability zone
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  name        = "shared_efs_sg_${var.region}"
  description = "Security group for Shared EFS in region ${var.region}"
  vpc_id      = aws_vpc.shared_vpc.id

  ingress {
    description     = "Allow from study services"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_service_study.id]
  }

  ingress {
    description     = "Allow from datasync service"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.datasync-efs-source.id]
  }

  # Allow all outbound traffic by default
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

