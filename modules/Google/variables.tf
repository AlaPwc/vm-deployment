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