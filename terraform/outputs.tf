output "instance_id" {
  value = aws_instance.webapp_server.id
}

output "db_identifier" {
  value = aws_db_instance.database.identifier
}