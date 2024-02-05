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
  basic_auth_username = var.influxdb_user
  secure_json_data_encoded = jsonencode({
    basicAuthPassword = var.influxdb_passwd
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
  basic_auth_username = var.influxdb_user
  secure_json_data_encoded = jsonencode({
    basicAuthPassword = var.influxdb_passwd
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