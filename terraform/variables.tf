variable project {
  description = "infra-249015"
}

variable region {
  description = "Region"

  # Значениепоумолчанию
  default = "us-west1-b"
}

variable public_key_path {
  # Описание переменной 
  description = "~/.ssh/appuser.pub"
}

variable private_key_path {
  # Описание переменной 
  description = "~/.ssh/appuser"
}

variable disk_image {
  description = "reddit-full-1565801744"
}

variable "app_count" {
  description = "Count of provisioned application nodes"
}
