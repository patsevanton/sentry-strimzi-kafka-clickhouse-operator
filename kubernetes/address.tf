module "address" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-address.git"

  ip_address_name = "apatsev-pip"
  folder_id = "xxxx"
  zone = "ru-central1-a"
}