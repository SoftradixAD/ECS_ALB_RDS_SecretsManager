# resource "aws_lb_target_group" "main" {
#   name                      = "test-tg"
#   port                      = 80
#   protocol                  = "HTTP"
#   target_type               = "ip"
#   vpc_id                    = aws_vpc.main.id
#   health_check {
#       path                  = "/"
#       protocol              = "HTTP"
#       matcher               = "200"
#       port                  = "traffic-port"
#       healthy_threshold     = 2
#       unhealthy_threshold   = 2
#       timeout               = 10
#       interval              = 30
#   }
# }