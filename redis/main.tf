module "redis" {
  source  = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-redis.git?ref=password"

  folder_id   = "xxxx"
  name        = "apatsev-redis"
  network_id  = "xxxxx"
  password    = "secretpassword"
  zone        = "ru-central1-a"
  hosts = {
    host1 = {
      zone      = "ru-central1-a"
      subnet_id = "xxxxx"
    }
  }
}
