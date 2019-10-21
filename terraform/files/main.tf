terraform {
  # Версия terraform
  required_version = "0.11.7"
}

provider "google" {
  # Версияпровайдера  version = "2.0.0"
  # ID проекта
  project = "${var.project}"

  region = "${var.region}"
}

// Adding SSH Public Key
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}appuser3:${file(var.public_key_path)}"
}

resource "google_compute_instance" "app" {
  name         = "reddit-full${count.index}"
  tags         = ["reddit-app"]
  machine_type = "g1-small"
  zone         = "${var.region}"
  count        = "${var.app_count}"

  # определениезагрузочногодиска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "~/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}
