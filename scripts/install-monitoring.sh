#!/bin/bash
# Prometheus + Grafana Installation Script
# Ubuntu 22.04

echo "========================================="
echo " Monitoring Stack Installation"
echo " Prometheus + Grafana + Node Exporter"
echo "========================================="

# ── PROMETHEUS ────────────────────────────────
echo ">>> Installing Prometheus..."

# Create user
sudo useradd --no-create-home --shell /bin/false prometheus 2>/dev/null || true

# Create directories
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# Download Prometheus
cd /tmp
wget -q https://github.com/prometheus/prometheus/releases/download/v2.51.0/prometheus-2.51.0.linux-amd64.tar.gz
tar xf prometheus-2.51.0.linux-amd64.tar.gz
cd prometheus-2.51.0.linux-amd64

# Copy files
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus

# Fix ownership
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Copy config
sudo cp /home/ubuntu/devops-monitoring-project/prometheus/prometheus.yml /etc/prometheus/
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Create Prometheus service
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus Monitoring
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
echo "✅ Prometheus installed - running on port 9090"

# ── NODE EXPORTER ─────────────────────────────
echo ">>> Installing Node Exporter..."

cd /tmp
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xf node_exporter-1.7.0.linux-amd64.tar.gz
sudo cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/

sudo useradd --no-create-home --shell /bin/false node_exporter 2>/dev/null || true
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
echo "✅ Node Exporter installed - running on port 9100"

# ── GRAFANA ───────────────────────────────────
echo ">>> Installing Grafana..."

sudo apt install -y apt-transport-https software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update && sudo apt install grafana -y

sudo systemctl start grafana-server
sudo systemctl enable grafana-server
echo "✅ Grafana installed - running on port 3000"

# ── SUMMARY ───────────────────────────────────
echo ""
echo "========================================="
echo " Monitoring Stack Ready!"
echo "========================================="
echo " Prometheus : http://YOUR-IP:9090"
echo " Grafana    : http://YOUR-IP:3000"
echo " Node Exp   : http://YOUR-IP:9100"
echo ""
echo " Grafana default login:"
echo " Username: admin"
echo " Password: admin"
echo "========================================="
