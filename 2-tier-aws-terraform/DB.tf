resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

}

resource "aws_db_instance" "mydatabase" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.4"
  instance_class         = "db.t3.micro"
  identifier             = "db-instance"
  db_name                = "mydatabase"
  username               = "admin"
  password               = "password"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true

}
