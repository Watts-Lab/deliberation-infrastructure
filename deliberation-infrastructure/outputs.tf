// network.tf
output "aws_vpc_shared_vpc_id" {
  description = "project vpc id"
  value       = aws_vpc.shared_vpc.id
}
output "aws_ecs_cluster_id" {
  description = "ecs cluster id"
  value       = aws_ecs_cluster.project_cluster.id
}

output "aws_subnet_public1_id" {
  description = "aws_subnet.public1 id"
  value       = aws_subnet.public1.id
}

output "aws_subnet_public2_id" {
  description = "aws_subnet.public2 id"
  value       = aws_subnet.public2.id
}

//alb.tf
output "aws_lb_app_alb_dns_name" {
  description = "load balancer dns name"
  value       = aws_lb.app_alb.dns_name
}

output "aws_lb_app_alb_zone_id" {
  description = "load balancer zone id"
  value       = aws_lb.app_alb.zone_id
}

output "aws_lb_target_group_app_alb_target_group_arn" {
  description = "alb target group arn"
  value       = aws_lb_target_group.app_alb_target_group.arn
}

// securityGroups.tf
output "aws_security_group_ecs_service_study_sg_id" {
  description = "security group id for study ecs service"
  value       = aws_security_group.ecs_service_study.id
}

// iam.tf
output "aws_iam_role_app_ecs_task_role_arn" {
  description = "aws iam role app_ecs_task_role arn"
  value       = aws_iam_role.app_ecs_task_role.arn
}

output "aws_iam_role_app_ecs_task_execution_role_arn" {
  description = "aws iam role app_ecs_task_execution_role arn"
  value       = aws_iam_role.app_ecs_task_execution_role.arn
}

// shared_efs.tf
output "aws_shared_efs_id" {
  description = "aws shared efs id"
  value       = aws_efs_file_system.shared_efs.id
}


// maybe unneeded below?
output "aws_route53_zone_selected_zone_id" {
  description = "zone ID of the route53 zone"
  value       = data.aws_route53_zone.selected.zone_id
}






