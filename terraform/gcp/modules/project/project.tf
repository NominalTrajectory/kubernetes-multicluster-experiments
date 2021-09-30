resource "google_project" "kme-gcp-project" {
    name = var.gcp_project_name
    project_id = var.gcp_project_id
    billing_account = var.gcp_billing_account
    org_id = var.gcp_org_id
    auto_create_network = false
}

resource "google_project_service" "kme-gcp-project-service" {
    project = google_project.kme-gcp-project.number
    service = var.gcp_enable_apis
}

