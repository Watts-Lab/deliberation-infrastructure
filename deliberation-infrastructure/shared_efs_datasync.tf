# Set up a datasync task/protocol to sync data from the deliberation-empirica efs volume to S3
# This serves as a backup of the data in the EFS volume, 
# and makes it easier to browse what has been saved to the file system

data "aws_s3_bucket" "wattslab-deliberation-backup" {
  bucket = "wattslab-deliberation-backup"
}

resource "aws_datasync_location_efs" "sourceEFS" {
  efs_file_system_arn = aws_efs_mount_target.shared_efs_mount_target.file_system_arn

  ec2_config {
    security_group_arns = [aws_security_group.datasync-efs-source.arn]
    subnet_arn          = aws_subnet.public1.arn
  }
}

// attach a security group to the datasync source location representation
resource "aws_security_group" "datasync-efs-source" {
  name        = "datasync-efs-source-${var.region}"
  description = "DataSync security group for EFS Sources"
  vpc_id      = aws_vpc.shared_vpc.id
}

// add a security group rule to allow outbound traffic to the efs security group
// need to separate out the rule to avoid a circular dependency
resource "aws_security_group_rule" "efs_datasync_egress" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.datasync-efs-source.id
  source_security_group_id = aws_security_group.efs_sg.id
}

resource "aws_datasync_location_s3" "destinationS3" {
  s3_bucket_arn = data.aws_s3_bucket.wattslab-deliberation-backup.arn
  subdirectory  = "/deliberation-empirica/"

  s3_config {
    // I don't understand why the S3 gets a role, instead of a security group...
    bucket_access_role_arn = aws_iam_role.datasync.arn
  }
}

resource "aws_cloudwatch_log_group" "datasync_log_group" {
  name = "/aws/datasync_deliberation_empirica_S3"
}

resource "aws_datasync_task" "backupSharedEfsToS3" {
  name                     = "backupSharedEfsToS3"
  source_location_arn      = aws_datasync_location_efs.sourceEFS.arn
  destination_location_arn = aws_datasync_location_s3.destinationS3.arn
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.datasync_log_group.arn
  options {
    log_level = "BASIC"
  }

  schedule {
    schedule_expression = "cron(0 * * * ? *)" # every hour
  }
}
