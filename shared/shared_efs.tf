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
  creation_token = "shared_efs"
  tags = {
    Name = "shared_efs"
  }
  encrypted = true
}

resource "aws_efs_mount_target" "shared_efs" {
  file_system_id  = aws_efs_file_system.shared_efs.id
  subnet_id       = aws_subnet.public1.id # EFS mount target must be in at least one availability zone Q: What does this mean?
  security_groups = [aws_security_group.shared_efs.id]
}

resource "aws_security_group" "shared_efs" {
  name        = "shared_efs_sg"
  description = "Security group for Shared EFS"
  vpc_id      = aws_vpc.shared_vpc.id

  ingress {
    description     = "Allow from empirca services (study, scheduling, video-coding)"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_services.id]
  }

  ingress {
    description     = "Allow from datasync service"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.data_backup_source.id]
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

