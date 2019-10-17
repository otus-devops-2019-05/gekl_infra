variable project {
  description = "Project ID"
  default = "infra-249015"
}

variable region {
  description = "Region"

  #  Значение по умолчанию
  default = "us-west1"
}

variable public_key_path {
  #  Описание переменной
  description = "Path to the public key used for ssh access"
  default = "~/.ssh/appuser.pub"
}

variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
  default = "~/.ssh/appuser"
}

variable disk_image {
  description = "Disk image"
  default = "reddit-full-1565801744"
}

variable zone {
  description = "Zone"

  # Значение по умолчанию
  default = "us-west1-b"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
