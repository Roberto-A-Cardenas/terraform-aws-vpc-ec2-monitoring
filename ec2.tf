# Security group for public instance
resource "aws_security_group" "public_sg" {
  name        = "public-instance-sg"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-instance-sg"
  }
}

# Security group for private instance
resource "aws_security_group" "private_sg" {
  name        = "private-instance-sg"
  description = "Allow SSH from public instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-instance-sg"
  }
}

# IAM role for EC2 CloudWatch monitoring
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "ec2-cloudwatch-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}

# Public EC2 Instance
resource "aws_instance" "public_instance" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  monitoring                  = true

  tags = {
    Name = "public-instance"
  }
}

# Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  monitoring             = true

  tags = {
    Name = "private-instance"
  }
}

# CloudWatch Alarm for high CPU on public instance
resource "aws_cloudwatch_metric_alarm" "public_high_cpu" {
  alarm_name          = "Public-Instance-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggered when CPU > 70% for 2 minutes"
  dimensions = {
    InstanceId = aws_instance.public_instance.id
  }
  alarm_actions = [] # Add SNS topic ARN here if you want email alerts
}
