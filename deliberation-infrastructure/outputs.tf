output "aws_subnet_public1_id" {
  description = "aws_subnet.public1 id"
  value       = aws_subnet.public1.id
}

output "aws_subnet_public2_id" {
  description = "aws_subnet.public2 id"
  value       = aws_subnet.public2.id
}

output "aws_route53_zone_selected_zone_id" {
  description = "zone ID of the route53 zone"
  value       = data.aws_route53_zone.selected.zone_id
}

output "aws_lb_app_alb_dns_name" {
  description = "load balancer dns name"
  value       = aws_lb.app_alb.dns_name
}

output "aws_lb_app_alb_zone_id" {
    description = "load balancer zone id"
    value = aws_lb.app_alb.zone_id
}

output "aws_vpc_project_vpc_id" {
    description = "project vpc id"
    value = aws_vpc.project_vpc.id
}

output "aws_ecs_cluster_id" {
  description = "ecs cluster id"
  value = aws_ecs_cluster.project_cluster.id
}
output "aws_lb_target_group_app_alb_target_group_arn" {
  description = "alb target group arn"
  value = aws_lb_target_group.app_alb_target_group.arn
}

output "aws_iam_role_app_ecs_task_role_arn" {
  description = "aws iam role app_ecs_task_role arn"
  value = aws_iam_role.app_ecs_task_role.arn
}

output "aws_iam_role_app_ecs_task_execution_role_arn" {
  description = "aws iam role app_ecs_task_execution_role arn"
  value = aws_iam_role.app_ecs_task_execution_role.arn
}

output "aws_security_group_app_ecs_task_sg_id" {
  description = "security group for ecs task id"
  value = aws_security_group.app_ecs_task_sg.id
}