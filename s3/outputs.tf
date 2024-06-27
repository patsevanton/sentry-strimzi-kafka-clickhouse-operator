output "access_key" {
  value       = module.s3.storage_admin_access_key
}

output "secret_key" {
  value       = module.s3.storage_admin_secret_key
  sensitive = true
}
