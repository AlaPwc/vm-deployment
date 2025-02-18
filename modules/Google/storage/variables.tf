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


variable "bucket_prefix" {
  description = "Prefix for the bucket name"
  type        = string
  default     = "cloudx-"
}

variable "storage_class" {
  description = "Storage class of the bucket"
  type        = string
  default     = "STANDARD" # Options: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE
}
