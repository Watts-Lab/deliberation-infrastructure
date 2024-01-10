// network.tf
output "aws_vpc_shared_vpc_id" {
  description = "project vpc id"
  value       = aws_vpc.shared_vpc.id
}
output "aws_ecs_cluster_shared_cluster_id" {
  description = "ecs cluster id"
  value       = aws_ecs_cluster.shared_cluster.id
}

output "aws_subnet_public1_id" {
  description = "aws_subnet.public1 id"
  value       = aws_subnet.public1.id
}

output "aws_subnet_public2_id" {
  description = "aws_subnet.public2 id"
  value       = aws_subnet.public2.id
}

// alb.tf

output "aws_lb_shared_alb_dns_name" {
  description = "aws_lb.shared_alb.dns_name"
  value       = aws_lb.shared_alb.dns_name
}

output "aws_lb_shared_alb_zone_id" {
  description = "aws_lb.shared_alb.zone_id"
  value       = aws_lb.shared_alb.zone_id
}
output "aws_lb_listener_HTTPS_arn" {
  description = "aws_lb_listener.HTTPS.arn"
  value       = aws_lb_listener.HTTPS.arn

}

# output "aws_lb_target_group_scheduler_arn" {
#   description = "ARN for scheduler target group from shared load balancer"
#   value       = aws_lb_target_group.scheduler.arn
# }

output "aws_lb_target_group_etherpad_arn" {
  description = "ARN for etherpad target group from shared load balancer"
  value       = aws_lb_target_group.etherpad.arn
}

// securityGroups.tf
output "aws_security_group_ecs_services_id" {
  description = "security group id for empirica ecs services"
  value       = aws_security_group.ecs_services.id
}

// iam.tf
output "aws_iam_role_ecs_task_role_arn" {
  description = "aws iam role ecs_task arn"
  value       = aws_iam_role.ecs_task.arn
}

output "aws_iam_role_ecs_task_exec_role_arn" {
  description = "aws iam role ecs_task_exec arn"
  value       = aws_iam_role.ecs_task_exec.arn
}

// shared_efs.tf
output "aws_shared_efs_id" {
  description = "aws shared efs id"
  value       = aws_efs_file_system.shared_efs.id
}




