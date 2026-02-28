resource "aws_db_subnet_group" "db_subnet" {
  subnet_ids = [aws_subnet.private.id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "appdb"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name

  publicly_accessible = false
}