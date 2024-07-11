output "fqdn_database" {
  value = "c-${module.db.cluster_id}.rw.mdb.yandexcloud.net"
  sensitive   = false
}

output "owners_data" {
  description = "List of owners with passwords."
  sensitive   = true
  value       = module.db.owners_data
}

output "databases" {
  description = "List of databases names."
  value       = module.db.databases
}
