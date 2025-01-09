resource "aws_instance" "main" {
  ami           = "ami-053b12d3152c0cc71" # Replace with a region-specific AMI if needed
  instance_type = "t2.micro"
  key_name      = "softradixad"
  associate_public_ip_address = true
  subnet_id = aws_subnet.private.id
  root_block_device {
    volume_size           = 10
    delete_on_termination = true
    volume_type           = "gp2"
  }

  iam_instance_profile = 	"SSMManagedInstanceCore"

  # Attach a security group
  vpc_security_group_ids = [aws_security_group.main.id]

#   # Optional: Add user data for initialization
#   user_data = <<-EOF
#               #!/bin/bash
#               yum update -y
#               yum install -y httpd
#               systemctl start httpd
#               systemctl enable httpd
#               echo "Welcome to the EC2 instance!" > /var/www/html/index.html
#               EOF

  tags = {
    Name = "Main_instance"
  }

  depends_on = [aws_vpc.main]
}



resource "aws_security_group" "main" {
  name        = "main-instance-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main.id 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere. Restrict this in production.
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic.
  }

  tags = {
    Name = "Main_Instance_Security_Group"
  }
  depends_on = [aws_vpc.main]
}


output "instance_ip" {
    value = [ aws_instance.main.public_ip ]
}

output "instance_id" {
    value = [ aws_instance.main.id ]
}

output "subnet_id" {
    value = [ aws_subnet.public.id, aws_subnet.public2.id ]
}

