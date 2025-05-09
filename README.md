![Terraform](https://img.shields.io/badge/Terraform-IaC-blue?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Deployed-orange?logo=amazon-aws)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

# AWS VPC with Public and Private Subnets using Terraform

This project provisions a secure and monitored AWS VPC using Terraform. It includes public and private subnets, EC2 instances, and CloudWatch monitoring. It’s a great example of Infrastructure as Code (IaC) for networking, compute, and observability.

## 🚀 What It Does

- Creates a custom VPC  
- Provisions one public and one private subnet  
- Deploys EC2 instances in each subnet  
- Configures security groups to control access:  
  - Public instance: SSH access from your IP  
  - Private instance: SSH access only from public EC2  
- Sets up an Internet Gateway and NAT Gateway  
- Enables detailed EC2 monitoring  
- Adds a CloudWatch alarm for high CPU usage  

## 📁 Project Structure

```
vpc-public-private/
├── main.tf          # VPC, Subnets, Internet Gateway, NAT, Routes
├── ec2.tf           # EC2 instances, security groups, IAM role, CloudWatch
├── variables.tf     # Input variables
├── outputs.tf       # Output values
└── README.md        # Project documentation
```

## ⚙️ How to Use

### 1. Update Variables

In `variables.tf`:
- `my_ip_cidr`: Your IP address with `/32`
- `key_name`: Your AWS EC2 key pair
- `ami_id`: Default is Amazon Linux 2 for `us-east-1`

### 2. Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

## 🔐 SSH Access

```bash
# Connect to public EC2 instance from your local machine
ssh -i path/to/key.pem ec2-user@<PUBLIC-IP>

# From the public instance, connect to the private instance
ssh ec2-user@<PRIVATE-IP>
```

## 🔐 Security Notes

- No public IP on the private instance  
- NAT Gateway allows outbound internet access for private subnet  
- SSH access is tightly controlled by security groups  

## 📊 Monitoring

- EC2 instances have detailed CloudWatch monitoring enabled  
- Alarm: CPU > 70% for 2 minutes on the public instance  

## 🧹 Cleanup

To avoid charges:

```bash
terraform destroy
```

## 🧠 Learning Outcomes

- AWS VPC networking (public/private subnets)  
- EC2 security group best practices  
- IAM role for EC2 + CloudWatch  
- Real-world infrastructure deployment using Terraform  

## 🏷️ Tags

`#terraform` `#aws` `#vpc` `#cloudwatch` `#devops` `#iac`
