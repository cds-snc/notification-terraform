data "github_repository" "notification_terraform" {
  name = "notification-terraform"
}

data "github_repository" "notification_manifests" {
  name = "notification-manifests"
}

data "github_repository" "notification_admin" {
  name = "notification-admin"
}

data "github_repository" "notification_api" {
  name = "notification-api"
}

data "github_repository" "notification_documentation" {
  name = "notification-documentation"
}

data "github_repository" "notification_document_download" {
  name = "notification-document-download-api"
}

data "github_repository" "ipv4_geolocate" {
  name = "ipv4-geolocate-webservice"
}

data "github_repository" "notification_system_status_frontend" {
  name = "notification-system-status-frontend"
}
