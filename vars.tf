variable "influxdb_public_user" {
  type = string
}

variable "influxdb_public_passwd" {
  type = string
  sensitive = true
}

variable "influxdb_url" {
  type = string
}

variable "influxdb_private_user" {
  type = string
}

variable "influxdb_private_passwd" {
  type = string
  sensitive = true
}

variable "opensearch_user" {
  type = string
}

variable "opensearch_passwd" {
  type = string
  sensitive = true
}

variable "opensearch_url" {
  type = string
}

variable "opensearch_index_pattern" {
  type = string
}


