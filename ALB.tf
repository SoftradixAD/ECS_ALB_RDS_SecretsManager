# resource "aws_lb" "main" {
#   name               = "main-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [ aws_security_group.alb_sg.id ]
#   subnets            = [ aws_subnet.public.id, aws_subnet.public2.id ]
#   enable_deletion_protection = false

#   enable_cross_zone_load_balancing = true

#   tags = {
#     Name = "main-alb"
#   }
# }


# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.main.arn
#   }
# }