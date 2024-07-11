output "fqdn_database" {
  value = "c-${module.db.cluster_id}.rw.mdb.yandexcloud.net"
  sensitive   = false
}

output "users_data" {
  value       = module.db.users_data
  sensitive   = true
}
