resource "aws_efs_file_system" "efs" {
  creation_token = "${var.app_name}_efs"
  tags = {
    Name = "${var.app_name}_efs"
  }
  encrypted = true
}

# Define the EFS mount target (must be in at least one availability zone)
resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.terraform_remote_state.shared.outputs.aws_subnet_public1_id
  security_groups = [aws_security_group.efs_sg.id]
}