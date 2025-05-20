# Security group for ALB
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "security grp for ALB"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

# create ALB
resource "aws_lb" "two_tier_alb" {
  name               = "two-tier-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

}

# Create ALB target group

resource "aws_lb_target_group" "alb-tg" {
  name       = "alb-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]
}


resource "aws_lb_target_group_attachment" "tg-attach1" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_instance.webserver_1.id
  port             = 80
  depends_on       = [aws_instance.webserver_1]

}

resource "aws_lb_target_group_attachment" "tg-attach2" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_instance.webserver_2.id
  port             = 80
  depends_on       = [aws_instance.webserver_2]
}

resource "aws_lb_listener" "listener_lb" {
  load_balancer_arn = aws_lb.two_tier_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn

  }

}

# Create route table to internet gateway

resource "aws_route_table" "rt-igw" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    name = "rt-igw"
  }

}
# Associate public subnets with route table
resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.rt-igw.id
}

resource "aws_route_table_association" "public_route_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.rt-igw.id
}

# Create security groups
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow web and ssh traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow web tier and ssh traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"]
    security_groups = [aws_security_group.public_sg.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
