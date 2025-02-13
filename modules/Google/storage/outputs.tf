
output "bucket_name" {
  description = "The name of the storage bucket"
  value       = google_storage_bucket.my_bucket.name
}

output "bucket_self_link" {
  description = "The self-link of the storage bucket"
  value       = google_storage_bucket.my_bucket.self_link
}

output "bucket_url" {
  description = "The public URL of the storage bucket"
  value       = "https://storage.googleapis.com/${google_storage_bucket.my_bucket.name}"
}

output "bucket_location" {
  description = "The region of the storage bucket"
  value       = google_storage_bucket.my_bucket.location
}
