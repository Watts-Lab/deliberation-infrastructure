# Set up an hourly datasync task to back up data 
# from the deliberation-empirica efs volume to S3.
#
# In addition to duplicating the data in the EFS volume, 
# this makes it easier to browse what has been saved to the file system

resource "aws_datasync_task" "data_backup" {
  name                     = "backup_shared_efs_to_S3"
  source_location_arn      = aws_datasync_location_efs.data_backup_source.arn
  destination_location_arn = aws_datasync_location_s3.data_backup_destination.arn
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.data_backup.arn
  options {
    log_level = "BASIC"
  }

  schedule {
    schedule_expression = "cron(0 * * * ? *)" # every hour
  }
}

resource "aws_cloudwatch_log_group" "data_backup" {
  name = "datasync_data_backup"
}



// Source location for the datasync task
resource "aws_datasync_location_efs" "data_backup_source" {
  efs_file_system_arn = aws_efs_mount_target.shared_efs.file_system_arn

  ec2_config {
    security_group_arns = [aws_security_group.data_backup_source.arn]
    subnet_arn          = aws_subnet.public1.arn
  }
}

// attach a security group to the datasync source location representation
resource "aws_security_group" "data_backup_source" {
  name        = "data_backup_source"
  description = "security group for datasync source"
  vpc_id      = aws_vpc.shared_vpc.id
}

// add a security group rule to allow outbound traffic to the efs security group
// need to separate out the rule to avoid a circular dependency
resource "aws_security_group_rule" "data_backup_source_egress" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.data_backup_source.id
  source_security_group_id = aws_security_group.shared_efs.id
}


// Destination location for the datasync task
// This bucket was created manually/permanently in the aws admin console
data "aws_s3_bucket" "data_backup_destination" {
  bucket = "deliberation-lab-backup"
}

resource "aws_datasync_location_s3" "data_backup_destination" {
  s3_bucket_arn = data.aws_s3_bucket.data_backup_destination.arn
  subdirectory  = "/"

  s3_config {
    // I don't understand why the S3 gets a role, instead of a security group...
    bucket_access_role_arn = aws_iam_role.datasync.arn
  }
}
