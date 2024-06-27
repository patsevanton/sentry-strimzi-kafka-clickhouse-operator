module "db" {
  source  = "git::https://github.com/terraform-yc-modules/terraform-yc-postgresql.git"

  network_id  = "xxxx"
  name        = "apatsev-postgresql"
  folder_id   = "xxxx"

  maintenance_window = {
    type = "WEEKLY"
    day  = "SUN"
    hour = "02"
  }

  hosts_definition = [
    {
      zone             = "ru-central1-a"
      assign_public_ip = true
      subnet_id        = "xxxx"
    }
  ]

  postgresql_config = {
    max_connections                = 395
  }

  databases = [
    {
      name       = "sentry"
      owner      = "sentry"
      lc_collate = "ru_RU.UTF-8"
      lc_type    = "ru_RU.UTF-8"
    }
  ]

  owners = [
    {
      name       = "sentry"
      conn_limit = 15
    }
  ]

  users = [
    {
      name        = "sentry-user"
      conn_limit  = 30
      permissions = ["sentry"]
    }
  ]
}
