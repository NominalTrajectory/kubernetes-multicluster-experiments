locals {
    network_cidr = "192.168.0.0/16"
    nodes_cidr = "192.168.1.0/24"
    pod_cidr = "10.98.0.0/16"
    service_cidr = "10.99.0.0/16"
}

resource "google_compute_network" "kme-cluster2-network" {
    name = "kme-cluster2-network"
    project = var.gcp_project_id
    auto_create_subnetworks = false
    routing_mode = "REGIONAL"
    mtu = 1500
}

resource "google_compute_subnetwork" "kme-cluster2-subnet" {
    name = "kme-cluster2-subnet"
    project = var.gcp_project_id
    ip_cidr_range = local.nodes_cidr
    region = var.gcp_location
    network = google_compute_network.kme-cluster2-network.self_link
    private_ip_google_access = true

    secondary_ip_range {
        range_name = "pod-ip-range"
        ip_cidr_range = local.pod_cidr
    }

    secondary_ip_range {
        range_name = "service-ip-range"
        ip_cidr_range = local.service_cidr
    }
}

resource "google_compute_router" "router" {
  name = "router"
  region = var.gcp_location
  project = var.gcp_project_id
  network = google_compute_network.kme-cluster2-network.self_link
}

resource "google_compute_router_nat" "nat" {
    name = "nat"
    project = var.gcp_project_id
    router = google_compute_router.router.name
    region = var.gcp_location
    nat_ip_allocate_option = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

    depends_on = [
      google_compute_subnetwork.kme-cluster2-subnet
    ]
}