# Repository for Grafana Dashboards used by the STFC Cloud

The yaml file [cloud_dashboards.yaml](cloud_dashboards.yaml) is used by Grafana to know where to pull provisioned dashboards from and set some rules with them.


### Current Dashboards:

- Hypervisor-Status:
    - Openstack Hypervisor Status: Shows the status of Hypervisors in Production

- Kiosk - Dashboards that are useful to have on rotation:
    - Openstack L flavor availability: Shows the availablity of all L flavors
    - Openstack GPU pool availability: Shows the availability of the GPU flavors
    - Openstack Hypervisor overview: Shows the status of Hypervisors as a whole
    - Openstack service availabilty: Shows the current status of each Openstack component

- Power Metrics:
    - Cloud power metrics: Shows the energy usage across a variety of machines along with cumulative measurements
    - Cloud rack average energy usage: Shows the energy usage across each rack

- Service Status:
    - Cloud VM details: Dashboard of the number of VMs over time.
    - Cloud VM overview: Overview of the current number of VMs in different states.
    - OpenStack service status: Shows the Status of services
    - OpenStack service status Breakdown: Breakdown of service statuses
    - OpenStack availability over time: Shows the average availability over a set time period
    - OpenStack Service Graphs: Shows the graphs for OpenStack Components

- Slots Available:
    - OpenStack GPU usage: GPU Usage on Production across all GPU flavors
    - Openstack slots available: Shows available flavor capacity for L and GPU flavors

- Weekly Reporting (WIP):
    - Weekly Reporting KH
    - WeeklyReports-DW
    - Kayobe Inventory KH
