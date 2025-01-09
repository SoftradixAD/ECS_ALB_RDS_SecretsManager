# Security Group for ECS tasks
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
  }

  # ingress {
  #   cidr_blocks = ["0.0.0.0/0"]
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }
}

# IAM Role for ECS Tasks
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "main-ecs-cluster"
}

# Launch Type Configuration for ECS Service
resource "aws_ecs_task_definition" "main" {
  family                   = "main-task-definition"
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

    # Define CPU and Memory at the task level (Required for Fargate)
  cpu    = "256"  # 256 CPU units
  memory = "512"  # 512 MiB of memory
  container_definitions = jsonencode([{
    name      = "main-container"
    image     = "nginx:latest"
    memory    = 512
    cpu       = 256
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      },
    ]
  }])
}

# ECS Service in Private Subnet
resource "aws_ecs_service" "main" {
  name            = "main-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = [aws_subnet.private.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.main.arn
  #   container_name   = "main-container"
  #   container_port   = 80
  # }

  health_check_grace_period_seconds = 60

  # depends_on = [aws_lb.main]  # Ensure ALB is created before ECS service
}