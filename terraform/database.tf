# RDS Postgres instance
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "airflow"
  username = "airflow"
  password = var.db_password

  # Place the RDS in the private subnets
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Keep it private — no direct internet access
  publicly_accessible = false

  # Don't create a snapshot when destroying — saves costs
  skip_final_snapshot = true

  tags = {
    Name    = "${var.project_name}-db"
    Project = var.project_name
  }
}