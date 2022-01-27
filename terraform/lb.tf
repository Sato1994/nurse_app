# alb###########################################################
resource "aws_lb" "alb" {
  name = "alb"
  load_balancer_type = "application"
  internal = false
  idle_timeout = 60
  enable_deletion_protection = false

  subnets = [
    aws_subnet.public-1a.id,
    aws_subnet.public-1c.id
  ]

  access_logs {
    bucket = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
  ]
}
################################################################

# リスナー######################################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "koreha http"
      status_code = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.certificate.arn
  ssl_policy = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "koreha https"
      status_code = "200"
    }
  }
}
resource "aws_lb_listener_rule" "to_target_group" {
  listener_arn = aws_lb_listener.https.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.front_container.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
################################################################

# ターゲットグループ ###########################################
resource "aws_lb_target_group" "front_container" {
  name = "front"
  target_type = "ip"
  vpc_id = aws_vpc.vpc.id
  port = "80"
  protocol = "HTTP"
  deregistration_delay = 300
  depends_on = [aws_lb.alb]

  health_check {
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = 200
    port = "traffic-port"
    protocol = "HTTP"
  }
}
################################################################