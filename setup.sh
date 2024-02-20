#!/bin/bash
# Install Grafana
apt-get install -y apt-transport-https software-properties-common wget
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install grafana
# Configure Grafana config
cat grafana.ini >> /etc/grafana/grafana.ini
# Create a systemd override to run Grafana on a port < 1024
mkdir /etc/systemd/system/grafana-server.service.d
cat override.ini > /etc/systemd/system/grafana-server.service.d/override.conf
# Move git script to sbin
cp provision_dashboards.sh /usr/sbin/provision_dashboards.sh
# Create a cron job to keep the dashboards updated in the provisioning folder
crontab -l > grafanacron
echo "* * * * * /usr/local/sbin/provision_dashboards.sh" >> grafanacron
crontab grafanacron
rm grafanacron
# Restart Grafana
systemctl restart grafana-server.service