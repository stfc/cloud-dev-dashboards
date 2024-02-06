terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.0.0"
    }
  }
}
provider "grafana" {
  url      = "http://localhost:3000"
  auth = "admin:admin"
}

resource "grafana_organization" "public" {
  name         = "Public Org"
}

resource "grafana_organization" "private" {
  name         = "Private Org"
}

resource "grafana_data_source" "influx_db_public" {
  org_id = grafana_organization.public.id
  type                = "influxdb"
  name                = "influxdb-public"
  uid                 = "influxdb-public"
  url                 = var.influxdb_url
  database_name = "cloud"
  basic_auth_enabled  = true
  basic_auth_username = var.influxdb_public_user
  secure_json_data_encoded = jsonencode({
    basicAuthPassword = var.influxdb_public_passwd
  })
}

resource "grafana_data_source" "influx_db_private" {
  org_id = grafana_organization.private.id
  type                = "influxdb"
  name                = "influxdb-private"
  uid                 = "influxdb-private"
  url                 = var.influxdb_url
  database_name = "cloud"
  basic_auth_enabled  = true
  basic_auth_username = var.influxdb_private_user
  secure_json_data_encoded = jsonencode({
    basicAuthPassword = var.influxdb_private_passwd
  })
}

resource "grafana_data_source" "opensearch_public" {
  org_id = grafana_organization.public.id
  name = "opensearch-public"
  type = "elasticsearch"
  uid = "opensearch"
  url = var.opensearch_url
  database_name = var.opensearch_index_pattern
  basic_auth_enabled = true
  basic_auth_username = var.opensearch_user
  secure_json_data_encoded = jsonencode({
    basicAuthPassword = var.opensearch_passwd
  })
  json_data_encoded = jsonencode({
    time_field    = "@timestamp"
    es_version    = "2.3.0"
    time_interval = "10s"
  })
}

resource "grafana_data_source" "opensearch_private" {
  org_id = grafana_organization.private.id
  name = "opensearch-private"
  type = "elasticsearch"
  uid = "opensearch"
  url = var.opensearch_url
  database_name = var.opensearch_index_pattern
  basic_auth_enabled = true
  basic_auth_username = var.opensearch_user
  secure_json_data_encoded = jsonencode({
    basicAuthPassword = var.opensearch_passwd
  })
  json_data_encoded = jsonencode({
    time_field    = "@timestamp"
    es_version    = "2.3.0"
    time_interval = "10s"
  })
}

resource "grafana_dashboard" "public_dashboard" {
  for_each = fileset(path.module, "dashboards/public/*.json")
  config_json = file("${path.module}/${each.key}")
  org_id = grafana_organization.public.id
}

resource "grafana_dashboard" "private_dashboard" {
  for_each = fileset(path.module, "dashboards/private/*.json")
  config_json = file("${path.module}/${each.key}")
  org_id = grafana_organization.private.id
}