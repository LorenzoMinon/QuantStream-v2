output "rds_endpoint" {
  description = "RDS Postgres endpoint"
  value       = aws_db_instance.main.endpoint
}
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main.public_ip
}