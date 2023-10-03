resource "aws_ecs_cluster" "ecs_cluster" {
  name = "demo-cluster"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "demo-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 2
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "demo_cp" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "task-definition-demo-family"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::877879097973:role/ecsTaskExecutionRole"
  cpu                = 512
  memory             = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = file("task-definitions/container-def.json")
}

resource "aws_ecs_service" "ecs_service" {
  name            = "demo-ecs-service_2"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2

  network_configuration {
    subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
    security_groups = [aws_security_group.security_group.id]
  }

  /* force_new_deployment = true


  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  } */

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "demo-container"
    container_port   = 5000
  }

  depends_on = [aws_autoscaling_group.ecs_asg]
}

resource "aws_cloudwatch_log_group" "demo_lg" {
  name = "/ecs/container"


}
