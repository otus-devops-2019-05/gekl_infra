terraform {
  backend "gcs" {
    bucket = "infra-249015-tfstate-stage"
    prefix = "stage"
  }
}
