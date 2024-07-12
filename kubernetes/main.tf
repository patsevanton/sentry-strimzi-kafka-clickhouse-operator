module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account"

  name      = "iam-yandex-kubernetes"
  folder_roles = [
    "container-registry.images.puller",
    "k8s.clusters.agent",
    "k8s.tunnelClusters.agent",
    "load-balancer.admin",
    "logging.writer",
    "vpc.privateAdmin",
    "vpc.publicAdmin",
    "vpc.user",
  ]
  folder_id = "xxxx"

}

module "kube" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-kubernetes.git"

  folder_id  = "xxxx"
  network_id = "xxxx"

  name = "k8s-apatsev"

  service_account_id      = module.iam_accounts.id
  node_service_account_id = module.iam_accounts.id

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "xxxx"
    }
  ]

  node_groups = {
    "auto-scale" = {
      nat    = true
      cores  = 6
      memory = 12
      auto_scale = {
        min     = 4
        max     = 6
        initial = 4
      }
    }
  }

  depends_on = [ module.iam_accounts ]

}
