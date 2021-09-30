locals {
    secondary_ip_ranges = {
        "pod-ip-range" = "10.0.0.0/14"
        "services-ip-range" = "10.4.0.0/19"
    }
}   

resource "google_compute_network" "main" {
    name = "main"
    project = var.gcp_project_name
    auto_create_subnetworks = false
    routing_mode = "REGIONAL"
    mtu = 1500
}

resource "google_compute_subnetwork" "private" {
    name = "private"
    project = var.gcp_project_id
    ip_cidr_range = "10.5.0.0/20"
    region = var.gcp_location
    network = google_compute_network.main.self_link
    private_ip_google_access = true

    dynamic "secondary_ip_range" {
        for_each = local.secondary_ip_ranges

        content {
            range_name = secondary_ip_range.key
            ip_cidr_range = secondary_ip_range.value
        }
    }
}

resource "google_compute_router" "router" {
  name = "router"
  region = var.gcp_location
  project = var.gcp_project_id
  network = google_compute_network.main.self_link
}

resource "google_compute_router_nat" "nat" {
    name = "nat"
    project = var.gcp_project_id
    router = google_compute_router.router.name
    region = var.gcp_location
    nat_ip_allocate_option = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

    depends_on = [
      google_compute_subnetwork.private
    ]
}