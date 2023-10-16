// The container for the service
resource "aws_ecs_service" "etherpad" {
  name                               = "etherpad-service"
  cluster                            = data.terraform_remote_state.shared.outputs.aws_ecs_cluster_shared_cluster_id
  task_definition                    = aws_ecs_task_definition.launch_etherpad_container.arn
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
    target_group_arn = data.terraform_remote_state.shared.outputs.aws_lb_target_group_etherpad_arn
    container_name   = "etherpad_container_${var.environment}"
    container_port   = "9001"
  }
}

// Details of the deliberation-etherpad etherpad service itself
resource "aws_ecs_task_definition" "launch_etherpad_container" {
  family                   = "etherpad-task"
  network_mode             = "awsvpc"
  task_role_arn            = data.terraform_remote_state.shared.outputs.aws_iam_role_ecs_task_role_arn
  execution_role_arn       = data.terraform_remote_state.shared.outputs.aws_iam_role_ecs_task_exec_role_arn
  requires_compatibilities = ["FARGATE"]
  memory                   = 1024
  cpu                      = 512
  container_definitions = jsonencode([
    {
      "name" : "etherpad_container_${var.environment}",
      "image" : "ghcr.io/watts-lab/deliberation-etherpad:${var.deliberation_etherpad_tag}",
      "cpu" : 0,
      "portMappings" : [
        {
          "name" : "etherpad_tcp_9001",
          "containerPort" : 9001,
          "hostPort" : 9001,
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
          name  = "ADMIN_PASSWORD",
          value = var.ADMIN_PASSWORD
        },
        { 
          name = "APIKEY",
          value = var.APIKEY
        }
      ],

      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "etherpad_container_${var.environment}",
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs"
          # Q: do we want non-blocking logstreams?
        }
      }
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}



