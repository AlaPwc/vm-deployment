output "db_instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.db_instance.name
}

output "db_public_ip" {
  description = "Public IP address of the database instance"
  value       = google_sql_database_instance.db_instance.public_ip_address
}

output "db_private_ip" {
  description = "Private IP address of the database instance"
  value       = google_sql_database_instance.db_instance.private_ip_address
}

output "db_connection_name" {
  description = "Google Cloud SQL connection name"
  value       = google_sql_database_instance.db_instance.connection_name
}
