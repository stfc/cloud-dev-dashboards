#!/bin/bash
FOLDER=/etc/grafana/provisioning/dashboards

if [[ ! -d "$FOLDER/.git" ]]; then
 rm -rfv "$FOLDER"
 git clone https://github.com/stfc/cloud-grafana-dashboards.git "$FOLDER" || true
fi

cd "$FOLDER"
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if [[ "$BRANCH_NAME" == "main" ]]; then
   git fetch && git reset --h origin/main
fi