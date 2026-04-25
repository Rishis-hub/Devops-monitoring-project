#!/bin/bash
# Jenkins Installation Script - Ubuntu 22.04
# No GPG key issues - uses WAR file method

echo "========================================="
echo " Jenkins Installation Script"
echo " Ubuntu 22.04 - WAR File Method"
echo "========================================="

# Update system
echo ">>> Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Java 21
echo ">>> Installing Java 21..."
sudo apt install openjdk-21-jdk -y
java -version

# Install other tools
echo ">>> Installing Git, Maven, Ansible, Docker..."
sudo apt install git maven ansible docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# Create Jenkins user
echo ">>> Creating Jenkins user..."
id -u jenkins &>/dev/null || sudo useradd -m -d /var/lib/jenkins -s /bin/bash jenkins
sudo mkdir -p /var/lib/jenkins
sudo mkdir -p /opt/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo chown -R jenkins:jenkins /opt/jenkins

# Add jenkins to docker group
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu

# Download latest Jenkins WAR
echo ">>> Downloading Jenkins WAR..."
sudo wget -O /opt/jenkins/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war
ls -lh /opt/jenkins/jenkins.war

# Fix permissions
sudo chown -R jenkins:jenkins /opt/jenkins/

# Get Java path automatically
JAVA_PATH=$(dirname $(dirname $(readlink -f $(which java))))

# Create Jenkins service
echo ">>> Creating Jenkins service..."
sudo tee /etc/systemd/system/jenkins.service > /dev/null <<EOF
[Unit]
Description=Jenkins Automation Server
After=network.target

[Service]
Type=simple
User=jenkins
Environment="JENKINS_HOME=/var/lib/jenkins"
Environment="JAVA_HOME=$JAVA_PATH"
ExecStart=/usr/bin/java -Xmx512m -jar /opt/jenkins/jenkins.war --httpPort=8080
Restart=on-failure
RestartSec=15

[Install]
WantedBy=multi-user.target
EOF

# Start Jenkins
echo ">>> Starting Jenkins..."
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Wait for Jenkins to start
echo ">>> Waiting 90 seconds for Jenkins to start..."
sleep 90

# Show status
sudo systemctl status jenkins

# Show password
echo ""
echo "========================================="
echo " JENKINS ADMIN PASSWORD:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""
echo " Open browser: http://YOUR-EC2-IP:8080"
echo "========================================="
