module "redis" {
  source  = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-redis.git?ref=init"

  folder_id   = "xxxx"
  name        = "test-redis"
  subnet_id   = "xxxxx"
  network_id  = "xxxx"
  password    = "xxxx"
}
