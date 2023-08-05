# Set up a datasync task/protocol to sync data from the deliberation-empirica efs volume to S3

data "aws_iam_role" "datasync_role" {
    name = "datasync_role"
}

data "aws_s3_bucket" "wattslab-deliberation-backup" {
    bucket = "wattslab-deliberation-backup"
}

resource "aws_datasync_location_efs" "sourceEFS" {
    efs_file_system_arn = aws_efs_mount_target.efs_mount_target.file_system_arn

    ec2_config {
        security_group_arns = [aws_security_group.efs_sg.arn]
        subnet_arn          = data.terraform_remote_state.shared.outputs.aws_subnet_public1_arn
    }
} 

resource "aws_datasync_location_s3" "destinationS3" {
    s3_bucket_arn = data.aws_s3_bucket.wattslab-deliberation-backup.arn
    subdirectory = "/deliberation-empirica"
    s3_config {
        bucket_access_role_arn = data.aws_iam_role.datasync_role.arn
    }
}

resource "aws_datasync_task" "efsToS3" {
    source_location_arn      = aws_datasync_location_efs.sourceEFS.arn
    destination_location_arn = aws_datasync_location_s3.destinationS3.arn
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.datasync_log_group.arn
    name                     = "efsToS3"

    schedule {
      schedule_expression = "cron(0 * * * ? *)" # every hour
    }
}