output "password" {
  value     = module.redis.password
  sensitive = true
}

output "fqdn_redis" {
  value = module.redis.fqdn_redis
}
