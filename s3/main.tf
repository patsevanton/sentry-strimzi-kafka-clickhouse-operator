
module "s3" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-storage-bucket.git"

  bucket_name = "sentry-bucket-apatsev-dev"
  folder_id   = "xxxx"
}
