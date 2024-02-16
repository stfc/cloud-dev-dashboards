terraform {
			required_version = ">= 0.14.0"
			  required_providers {
			    openstack = {
			      source  = "terraform-provider-openstack/openstack"
			      version = "~> 1.53.0"
			    }
			  }
			}

provider "openstack" {
    cloud = "openstack"	# Uses the section called “openstack” from our app creds
}

# Creating the private network on Openstack and routing it to the external network

resource "openstack_networking_network_v2" "network" {
  name = "grafana-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name = "subnet"
  network_id = openstack_networking_network_v2.network.id
  cidr = var.subnet_cidr
  ip_version = 4
}

resource "openstack_networking_router_v2" "router" {
  name = "router"
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

# Create HTTP and SQL security groups

resource "openstack_networking_secgroup_v2" "http_secgroup" {
  name        = " private-HTTP"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "http_secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.http_secgroup.id
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_v2" "grafana_secgroup" {
  name        = " private-grafana"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "grafana_secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.grafana_secgroup.id
  protocol = "tcp"
  port_range_min = 3000
  port_range_max = 3000
  remote_ip_prefix  = "0.0.0.0/0"
}

# Creating the loadbalancer and associating a floating IP

resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name = "grafana-loadbalancer"
  vip_subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_networking_floatingip_associate_v2" "lb_fip" {
  floating_ip = var.lb_float_ip
  port_id = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id
}

# Creating loadbalancer listeners, pools and adding the VM as a member

resource "openstack_lb_listener_v2" "http_listener" {
  name = "http"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_pool_v2" "http_pool" {
  name = "http-pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.http_listener.id
}

resource "openstack_lb_listener_v2" "ssh_listener" {
  name = "ssh"
  protocol        = "TCP"
  protocol_port   = 2222
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
  timeout_client_data = 600000
  timeout_member_connect = 600000
  timeout_member_data = 600000
}

resource "openstack_lb_pool_v2" "ssh_pool" {
  name = "ssl-pool"
  protocol    = "TCP"
  lb_method   = "SOURCE_IP"
  listener_id = openstack_lb_listener_v2.ssh_listener.id
}

resource "openstack_lb_listener_v2" "grafana_listener" {
  name = "grafana"
  protocol        = "HTTPS"
  protocol_port   = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_pool_v2" "grafana_pool" {
  name = "grafana-pool"
  protocol    = "HTTPS"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.grafana_listener.id
}

resource "openstack_compute_instance_v2" "grafana_vm" {
        name  = "grafana-vm"
        image_name        = "ubuntu-focal-20.04-nogui"
        flavor_name       = "l3_nano"
        security_groups = ["default", openstack_networking_secgroup_v2.http_secgroup.name, openstack_networking_secgroup_v2.grafana_secgroup.name]
        key_pair        = var.ssh_public_key_name
    
    network {
        name = openstack_networking_network_v2.network.name
    }

    

}