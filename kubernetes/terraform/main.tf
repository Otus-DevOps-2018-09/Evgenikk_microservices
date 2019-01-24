provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_container_cluster" "primary" {
  name               = "k8s-terraform-cluster"
  zone               = "us-central1-a"
  initial_node_count = 2

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }
  }

  node_config {
    machine_type = "g1-small"
    disk_size_gb = "20"
    tags = ["kube-outports"]


    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_compute_firewall" "k8s" {
  name    = "kuber_and_puma"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
  source_tags = ["kube-outports"]
  description   = "kuber reddit apps"
  source_ranges = ["0.0.0.0/0"]
}