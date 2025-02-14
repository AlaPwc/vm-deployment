variable "project_id" {
  description = "GCP CloudX Showcase"
}

variable "region" {
  description = "GCP Region"
  default     = "europe-west10"
}

variable "zone" {
  description = "GCP Zone"
  default     = "europe-west10-a"
}
variable "GOOGLE_CREDENTIALS" {
  description = "Dummy variable for Google Cloud credentials"
  type        = string
  default     = "" # Provide an empty default value since this will be overridden by the environment variable
}


variable "db_instance_name" {
  description = "Cloud SQL instance name"
  type        = string
  default     = "my-cloud-sql-instance"
}

variable "db_version" {
  description = "Database engine and version"
  type        = string
  default     = "POSTGRES_15" # Change to MYSQL_8_0 for MySQL
}

variable "db_tier" {
  description = "Machine type for the database"
  type        = string
  default     = "db-f1-micro" # Cheapest option (for testing)
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "mydatabase"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}