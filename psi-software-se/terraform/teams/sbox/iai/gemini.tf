resource "google_apikeys_key" "gemini_api_key" {
  name         = "gemini-api-key"
  display_name = "Gemini API Key"
  project      = var.gcp_project_id

  restrictions {
    api_targets {
      service = "generativelanguage.googleapis.com"
    }
  }
}

output "gemini_api_key" {
  value = google_apikeys_key.gemini_api_key.key_string
  sensitive = true
}

