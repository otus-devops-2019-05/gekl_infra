resource "google_compute_forwarding_rule" "default" {
  name                  = "http-lb"
  region                = "us-west1"
  target                = "${google_compute_target_pool.default.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "9292"
}

resource "google_compute_target_pool" "default" {
  name             = "app-pool"
  region           = "us-west1"
  session_affinity = "NONE"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.default.name}",
  ]
}

resource "google_compute_http_health_check" "default" {
  name         = "check-reddit-full"
  request_path = "/"
  port         = "9292"
}
