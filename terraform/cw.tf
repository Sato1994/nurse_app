resource "aws_cloudwatch_log_group" "gadget-ecs-front" {
  name              = "/ecs/front"
  retention_in_days = 180
}