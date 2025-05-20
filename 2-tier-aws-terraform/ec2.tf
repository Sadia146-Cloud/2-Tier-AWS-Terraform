resource "aws_instance" "webserver_1" {
  ami                         = "ami-0e35ddab05955cf57"
  instance_type               = "t2.micro"
  key_name                    = "two-tier-aws-terraform"
  availability_zone           = "ap-south-1a"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_1.id

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
  tags = {
    Name = "webserver-1"
  }



}

resource "aws_instance" "webserver_2" {
  ami                         = "ami-0e35ddab05955cf57"
  instance_type               = "t2.micro"
  key_name                    = "two-tier-aws-terraform"
  availability_zone           = "ap-south-1b"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_2.id


  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
  tags = {
    Name = "webserver-2"
  }



}
