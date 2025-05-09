variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone"
  default     = "us-east-1a"
}
variable "my_ip_cidr" {
  description = "76.168.9.144 /32 CIDR for SSH access"
  default     = "76.168.9.144/32"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
}

variable "key_name" {
  description = "Name of your EC2 Key Pair"
  default     = "terraform-key"
}

