module "db" {
  source  = "git::https://github.com/terraform-yc-modules/terraform-yc-postgresql.git"

  network_id  = "xxxx"
  name        = "test-postgresql"
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
      name       = "test1"
      owner      = "test1"
      lc_collate = "ru_RU.UTF-8"
      lc_type    = "ru_RU.UTF-8"
    }
  ]

  owners = [
    {
      name       = "test1"
      conn_limit = 15
    }
  ]

  users = [
    {
      name        = "test1-guest"
      conn_limit  = 30
      permissions = ["test1"]
    }
  ]
}
