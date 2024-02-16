variable "lb_float_ip" {
  description = "The floating ip to associate to the load balancer."
  type = string 
}

variable "external_network_id" {
    description = "The UUID of the external network in your project."
    type = string
}

variable "ssh_public_key_name" {
  description = "The name of your SSH Key Pair on Openstack."
  type = string
}

variable "subnet_cidr" {
    description = "The CIDR block range for IP addresses on the network."
    type = string
    default = "192.168.100.0/24"
}

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


