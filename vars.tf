variable "influxdb_user" {
  type = string
}

variable "influxdb_passwd" {
  type = string
  sensitive = true
}

variable "influxdb_url" {
  type = string
}