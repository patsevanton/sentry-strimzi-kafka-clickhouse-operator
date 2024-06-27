module "kube" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-kubernetes.git"

  network_id = "xxxx"
  folder_id  = "xxxx"

  enable_default_rules = false

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "xxxx"
    }
  ]

  master_maintenance_windows = [
    {
      day        = "sunday"
      start_time = "00:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "yc-k8s-ng-01" = {
      description = "Kubernetes nodes group 01 with auto scaling"
      auto_scale = {
        min     = 1
        max     = 4
        initial = 1
      }
    },
  }
}
