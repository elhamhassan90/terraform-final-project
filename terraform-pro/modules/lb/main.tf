resource "aws_lb" "public" {
  name               = "elham-public-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.security_group_id]

  tags = {
    Name = "elham-public-alb"
  }
}

resource "aws_lb_target_group" "public" {
  name     = "elham-public-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public.arn
  }
}

resource "aws_lb_target_group_attachment" "public" {
  for_each = var.ec2_public_map
  target_group_arn = aws_lb_target_group.public.arn
  target_id        = each.value
  port             = 80
}

# Private Load Balancer
resource "aws_lb" "private" {
  name               = "elham-private-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids
  security_groups    = [var.security_group_id]

  tags = {
    Name = "elham-private-alb"
  }
}

resource "aws_lb_target_group" "private" {
  name     = "elham-private-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "private" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private.arn
  }
}

resource "aws_lb_target_group_attachment" "private" {
  for_each = var.ec2_private_map
  target_group_arn = aws_lb_target_group.private.arn
  target_id        = each.value
  port             = 80
}
