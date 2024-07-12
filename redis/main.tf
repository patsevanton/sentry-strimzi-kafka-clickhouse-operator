module "redis" {
  source  = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-redis.git"

  folder_id   = "xxxx"
  name        = "apatsev-redis"
  network_id  = "xxxxx"
  password    = "sentry-redis-password"
  zone        = "ru-central1-a"
  hosts = {
    host1 = {
      zone      = "ru-central1-a"
      subnet_id = "xxxxx"
    }
  }
}
