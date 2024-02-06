# cloud-dev-dashboards
Repository for Grafana Dashboards for the STFC Cloud

Current Dashboards:

- OpenStack Current Availability: Shows the current availability in Prod or PreProd.
- OpenStack Availability Over Time: Shows the average availability in Prod or PreProd over a set time.
- OpenStack Service Graphs: Shows the graphs for OpenStack Components in Prod or PreProd.
- OpenStack Hypervisor Status: Shows the Hypervisor status in Prod.
- OpenStack Service Status: Shows the Status of services in Prod or PreProd.
- OpenStack Service Status Breakdown: Breakdown of service statuses.
- OpenStack GPU Usage: GPU Usage on Prod across all GPU flavors.
- GPU Pool Availability: Availability of flavors across GPU Pools.
- Cloud Rack Energy Usage: Shows the energy usage across each rack.
- **[WIP]** Cloud VM Overview: Overview of the current number of VMs in different states.
- **[WIP]** Cloud VM Details: Dashboard of the number of VMs over time.

## Terraform Provisioning Script
### About the configuration
Terraform will create 2 different organisations: one public, one private.
The public organisation will be the default organisation for unauthenticated access to the Grafana Server.
The private organisation will require you to log in as admin and view from there.
Dashboards from the public/private folders will be added to their respeective organisation.
Currently when changing pages there is a chance that Grafana will redirect you to a page on localhost. This is an issue with the Grafana config and can be manually changed.
However, I have left this until we have a DNS record for the production Grafana instance.
### To use Terraform to provision the configuration of Grafana follow the below steps:
1. Create an Ubuntu VM on the internal network
1. Git clone this repository onto the VM: `git clone https://github.com/stfc/cloud-grafana-dashboards.git`
1. Git checkout to switch to this branch: `git checkout kh-terraform-provisioning`
1. Change directory to the git repo: `cd cloud-grafana-dashboards`
1. Run the setup script to install Terraform and Grafana: `sudo bash setup.sh`
1. Initialise Terraform in this directory: `terraform init`
1. Plan the Terraform changes. Here you will need to input logins for both the public and private Influxdb users and URL: `terraform plan -out plan`
1. Then apply the changes: `terraform apply plan`


