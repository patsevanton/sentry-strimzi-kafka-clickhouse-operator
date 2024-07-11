output "fqdn_redis" {
  value = module.redis.fqdn
}

output "password" {
  value     = module.redis.password
  sensitive = true
}
