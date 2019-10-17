terraform {
  backend "gcs" {
    bucket = "infra-249015-tfstate-prod"
    prefix = "prod"
  }
}
