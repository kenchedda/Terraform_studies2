# Application Load Balancer Resources
/*Creates an Application Load Balancer (ALB) that is accessible from the internet, uses the application load balancer 
type, and uses the ALB security group. The ALB will be created in all public subnets.*/
resource "aws_lb" "alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [for i in aws_subnet.public_subnet : i.id]
}

#creating a target group that listens on port 80 and uses the HTTP protocol. 
resource "aws_lb_target_group" "target_group" {
  name     = "${var.environment}-tgrp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path    = "/"
    matcher = 200
  }
}

#Application Load Balancer: Is a powerful tool that can help you improve the performance, security, and 
#availability of your applications
/*Creating a listener that listens on port 80 and uses the HTTP protocol. The listener will be associated 
with the application load balancer*/
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  tags = {
    Name = "${var.environment}-alb-listenter"
  }
}