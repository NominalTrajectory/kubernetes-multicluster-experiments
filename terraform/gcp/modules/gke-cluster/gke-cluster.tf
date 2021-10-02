resource "google_container_cluster" "kme-cluster-2" {
    name = "kme-cluster-2"
    project = var.gcp_project_id
    description = "Kubernetes Multi-cluster Experiments: Cluster 2"
    location = var.gcp_location
    remove_default_node_pool = true
    initial_node_count = 1
    subnetwork = var.subnet_self_link

    ip_allocation_policy {
      cluster_secondary_range_name = "pod-ip-range"
      services_secondary_range_name = "service-ip-range"
    }
}

resource "google_container_node_pool" "default-node-pool" {
  name = "defalt-node-pool"
  location = var.gcp_location
  cluster = google_container_cluster.kme-cluster-2.name
  node_count = 1

  node_config {
    preemptible = true
    machine_type = "e2-micro"
  }
}