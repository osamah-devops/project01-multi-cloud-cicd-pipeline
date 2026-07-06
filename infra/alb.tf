###############################
# Application Load Balancer
###############################

resource "aws_lb" "main" {

  name               = "main-alb"
  internal           = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Name = "Main-ALB"
  }

}

###############################
# Target Group
###############################

resource "aws_lb_target_group" "main" {

  name = "main-target-group"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2

  }

  tags = {
    Name = "Target-Group"
  }

}

###############################
# HTTP Listener
###############################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.main.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "redirect"

    redirect {

      port = "443"

      protocol = "HTTPS"

      status_code = "HTTP_301"

    }

  }

}

###############################
# HTTPS Listener
###############################

resource "aws_lb_listener" "https" {

  load_balancer_arn = aws_lb.main.arn

  port = 443

  protocol = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = var.certificate_arn

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.main.arn

  }

}