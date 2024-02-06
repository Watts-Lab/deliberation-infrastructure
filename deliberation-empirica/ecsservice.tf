// The empirica service 
resource "aws_ecs_service" "empirica" {
  name                               = "${var.subdomain}-empirica-service"
  cluster                            = data.terraform_remote_state.shared.outputs.aws_ecs_cluster_shared_cluster_id
  task_definition                    = aws_ecs_task_definition.empirica.arn
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
    target_group_arn = aws_lb_target_group.empirica.arn
    container_name   = "${var.subdomain}-empirica-container"
    container_port   = "3000"
  }
}

// Details of the deliberation-empirica study service itself
resource "aws_ecs_task_definition" "empirica" {
  family                   = "${var.subdomain}-empirica-task"
  network_mode             = "awsvpc"
  task_role_arn            = data.terraform_remote_state.shared.outputs.aws_iam_role_ecs_task_role_arn
  execution_role_arn       = data.terraform_remote_state.shared.outputs.aws_iam_role_ecs_task_exec_role_arn
  requires_compatibilities = ["FARGATE"]
  memory                   = var.memory
  cpu                      = var.cpu
  container_definitions = jsonencode([
    {
      "name" : "${var.subdomain}-empirica-container",
      "image" : "ghcr.io/watts-lab/deliberation-empirica:${var.deliberation_empirica_tag}",
      "cpu" : 0,
      "portMappings" : [
        {
          "name" : "empirica_tcp_3000",
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
          name  = "QUALTRICS_DATACENTER",
          value = var.QUALTRICS_DATACENTER
        },
        {
          name  = "TEST_CONTROLS",
          value = var.REACT_APP_TEST_CONTROLS
        },
        {
          name  = "DAILY_APIKEY",
          value = var.DAILY_APIKEY
        },
        {
          name  = "QUALTRICS_API_TOKEN",
          value = var.QUALTRICS_API_TOKEN
        },
        {
          name  = "DELIBERATION_MACHINE_USER_TOKEN",
          value = var.DELIBERATION_MACHINE_USER_TOKEN
        },
        {
          name  = "EMPIRICA_ADMIN_PW",
          value = var.EMPIRICA_ADMIN_PW
        },
        {
          name  = "DATA_DIR",
          value = var.app_data_path
        },
        {
          name  = "CONTAINER_IMAGE_VERSION_TAG",
          value = var.deliberation_empirica_tag
        },
        {
          name  = "AWS_REGION",
          value = var.region
        },
        {
          name  = "ENVIRONMENT",
          value = var.environment
        },
        {
          name  = "GITHUB_PRIVATE_DATA_OWNER",
          value = var.GITHUB_PRIVATE_DATA_OWNER
        },
        {
          name  = "GITHUB_PUBLIC_DATA_OWNER",
          value = var.GITHUB_PUBLIC_DATA_OWNER
        },
        {
          name  = "GITHUB_PRIVATE_DATA_REPO",
          value = var.GITHUB_PRIVATE_DATA_REPO
        },
        {
          name  = "GITHUB_PUBLIC_DATA_REPO",
          value = var.GITHUB_PUBLIC_DATA_REPO
        },
        {
          name  = "GITHUB_PRIVATE_DATA_BRANCH",
          value = var.GITHUB_PRIVATE_DATA_BRANCH
        },
        {
          name  = "GITHUB_PUBLIC_DATA_BRANCH",
          value = var.GITHUB_PUBLIC_DATA_BRANCH
        },
        {
          name  = "ETHERPAD_API_KEY",
          value = var.ETHERPAD_API_KEY
        },
        {
          name  = "ETHERPAD_BASE_URL",
          value = var.ETHERPAD_BASE_URL
        },
        {
          name  = "SUBDOMAIN",
          value = var.subdomain
        }
      ],
      mountPoints = [
        {
          containerPath = var.app_data_path,
          sourceVolume  = "shared_data_volume",
          readOnly      = false
        }
      ],
      "volumesFrom" : [],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "${var.subdomain}.deliberation-lab.org",
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
  volume {
    name = "shared_data_volume"

    efs_volume_configuration {
      file_system_id = data.terraform_remote_state.shared.outputs.aws_shared_efs_id
      root_directory = "/"
    }
  }
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}



