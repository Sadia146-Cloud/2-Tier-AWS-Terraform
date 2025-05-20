# Two-Tier AWS Architecture using Terraform

This project provisions a Two-Tier architecture on AWS using Terraform. It includes a public-facing web layer and a private backend layer with an RDS MySQL database.

---

## 🧱 Components Deployed

- VPC
- Internet Gateway
- Public and Private Subnets (across two AZs)
- Route Tables and Associations
- Security Groups (for ALB, EC2, RDS)
- Application Load Balancer (ALB)
- Two EC2 Instances (Nginx Web Servers)
- RDS MySQL Instance (Private)

---

## 📁 Project Structure
.
├── provider.tf

├── vpc.tf

├── security-resources.tf

├── ec2.tf

├── db.tf

# terraform init

# terraform plan

# terraform apply

#terraform destroy



