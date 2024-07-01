module "dns-zone" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-dns.git//modules/zone"

  folder_id = "xxxx"
  name        = "my-private-zone"

  zone             = "apatsev.org.ru."
  is_public        = false
  private_networks = ["xxxx"]
}

module "dns-recordset" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-dns.git//modules/recordset"

  folder_id = "xxxx"
  zone_id   = module.dns-zone.id
  name      = "sentry.apatsev.org.ru."
  type      = "A"
  ttl       = 200
  data      = [
    module.address.external_ipv4_address
  ]
}
