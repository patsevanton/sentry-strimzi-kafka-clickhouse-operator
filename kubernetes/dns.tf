module "dns-zone" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-dns.git//modules/zone"

  folder_id = "xxxx"
  name        = "my-private-zone"

  zone             = "apatsev.org.ru." # Точка в конце обязательна
  is_public        = true
  private_networks = ["xxxx"] # network_id
}

module "dns-recordset" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-dns.git//modules/recordset"

  folder_id = "xxxx"
  zone_id   = module.dns-zone.id
  name      = "sentry.apatsev.org.ru." # Точка в конце обязательна
  type      = "A"
  ttl       = 200
  data      = [
    module.address.external_ipv4_address
  ]
}
