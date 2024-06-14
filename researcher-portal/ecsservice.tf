// The empirica service 
resource "aws_ecs_service" "researcher_portal" {
  name                               = "researcher-portal-service"
  cluster                            = data.terraform_remote_state.shared.outputs.aws_ecs_cluster_shared_cluster_id
  task_definition                    = aws_ecs_task_definition.researcher_portal.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  enable_execute_command             = true

  network_configuration {
    security_groups  = [data.terraform_remote_state.shared.outputs.aws_security_group_ecs_services_id]
    subnets          = [data.terraform_remote_state.shared.outputs.aws_subnet_public1_id, data.terraform_remote_state.shared.outputs.aws_subnet_public2_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.researcher_portal.arn
    container_name   = "researcher-portal-container"
    container_port   = "3000"
  }
}

// Details of the deliberation-empirica study service itself
resource "aws_ecs_task_definition" "researcher_portal" {
  family                   = "researcher-portal-task"
  network_mode             = "awsvpc"
  task_role_arn            = data.terraform_remote_state.shared.outputs.aws_iam_role_ecs_task_role_arn
  execution_role_arn       = data.terraform_remote_state.shared.outputs.aws_iam_role_ecs_task_exec_role_arn
  requires_compatibilities = ["FARGATE"]
  memory                   = var.memory
  cpu                      = var.cpu
  container_definitions = jsonencode([
    {
      "name" : "researcher-portal-container",
      "image" : "ghcr.io/watts-lab/researcher-portal:${var.researcher_portal_tag}",
      "cpu" : 0,
      "portMappings" : [
        {
          "name" : "researcher_portal_tcp_3000",
          "containerPort" : 3000,
          "hostPort" : 3000,
          "protocol" : "tcp",
          "appProtocol" : "http"
        }
      ],
      "essential" : true,
      "linuxParameters" : {
        "initProcessEnabled" : true
      }
      "environment" : [
        {
          name  = "AWS_REGION",
          value = var.region
        },
        {
          name  = "ENVIRONMENT",
          value = var.environment
        },
        {
          name  = "SUBDOMAIN",
          value = var.subdomain
        }
      ],
      "volumesFrom" : [],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "researcher.deliberation-lab.org",
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}



