# クラスタ############################################################
resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
}
######################################################################

# タスク定義##########################################################
resource "aws_ecs_task_definition" "front_container" {
  family = "front_container"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = file("./definitions/front_container.json")
}
######################################################################

# ecsサービス#########################################################
resource "aws_ecs_service" "front_container" {
  name = "front_container"
  cluster = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.front_container.arn
  desired_count = 2
  launch_type = "FARGATE"
  platform_version = "1.3.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups = [module.front_sg.security_group_id]

    subnets = [
      aws_subnet.private-1a.id,
      aws_subnet.private-1c.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.front_container.arn
    container_name = "front_container"
    container_port = 80
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
######################################################################