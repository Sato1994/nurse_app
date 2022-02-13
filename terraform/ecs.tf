# クラスタ#######################################################################
resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
}
#################################################################################

# タスク定義#####################################################################
resource "aws_ecs_task_definition" "nurse_container" {
  family = "nurse_container"
  cpu = "512"
  memory = "1024"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = file("./definitions/nurse_container.json")
  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
}
#################################################################################

# ecsサービス####################################################################
resource "aws_ecs_service" "nurse" {
  name = "nurse"
  cluster = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.nurse_container.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups = [aws_security_group.ecs_sg.id]

    subnets = [
      aws_subnet.private-1a.id,
      aws_subnet.private-1c.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.front_container.arn
    container_name = "front_container"
    container_port = 8080
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
#################################################################################

# ecsタスク実行ポリシー##########################################################
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

data "aws_iam_policy_document" "ecs_task_execution" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

  statement {
    effect = "Allow"
    actions = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

module "ecs_task_execution_role" {
  source = "./iam_role"
  name = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"  
  policy = data.aws_iam_policy_document.ecs_task_execution.json
}
#################################################################################