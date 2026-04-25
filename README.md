# DevOps Monitoring Pipeline 🚀

A complete DevOps project integrating **Jenkins CI/CD**, **Docker**, **Ansible**, **Prometheus**, and **Grafana** for automated deployment with full monitoring.

---

## 🏗️ Architecture

```
Developer → Git Push → Jenkins Pipeline
                            ↓
                       Maven Build
                            ↓
                       Docker Image Build
                            ↓
                       Push to DockerHub
                            ↓
                       Ansible Deployment
                            ↓
                       App Running in Docker
                            ↓
                  Prometheus scrapes metrics
                            ↓
                  Grafana displays dashboards
```

---

## 🛠️ Tools & Technologies

| Tool         | Purpose                          |
|--------------|----------------------------------|
| Jenkins      | CI/CD Pipeline Orchestration     |
| Docker       | Containerization                 |
| Ansible      | Automated Deployment             |
| Prometheus   | Metrics Collection & Monitoring  |
| Grafana      | Visualization & Dashboards       |
| Maven        | Build & Dependency Management    |
| Git/GitHub   | Source Code Management           |
| AWS EC2      | Cloud Infrastructure             |

---

## 📁 Project Structure

```
devops-monitoring-project/
├── Jenkinsfile                    # CI/CD Pipeline
├── Dockerfile                     # App container
├── pom.xml                        # Maven build
├── README.md                      # Documentation
├── ansible/
│   ├── deploy.yml                 # Deployment playbook
│   └── inventory.ini              # Server inventory
├── prometheus/
│   └── prometheus.yml             # Prometheus config
├── grafana/
│   └── dashboard.json             # Grafana dashboard
├── app/
│   └── app.py                     # Sample application
└── scripts/
    ├── install-jenkins.sh         # Jenkins install script
    ├── install-monitoring.sh      # Prometheus+Grafana install
    └── health-check.sh            # Health check script
```

---

## 🚀 Setup Instructions

### Step 1 — Launch EC2 Instance
- AMI: Ubuntu 22.04 LTS
- Instance type: t3.medium
- Ports: 22, 8080, 9090, 3000, 80

### Step 2 — Install Jenkins
```bash
bash scripts/install-jenkins.sh
```

### Step 3 — Install Monitoring Stack
```bash
bash scripts/install-monitoring.sh
```

### Step 4 — Configure Jenkins Pipeline
- New Item → Pipeline
- SCM → Git → your repo URL
- Branch: main
- Script path: Jenkinsfile

### Step 5 — Access Services

| Service    | URL                        |
|------------|----------------------------|
| Jenkins    | http://YOUR-IP:8080        |
| Prometheus | http://YOUR-IP:9090        |
| Grafana    | http://YOUR-IP:3000        |
| App        | http://YOUR-IP:80          |

---

## 📊 Monitoring Setup

### Prometheus
- Scrapes metrics every 15 seconds
- Monitors: App health, Docker containers, System metrics

### Grafana
- Default login: admin/admin
- Pre-built dashboard for application metrics
- Alerts configured for high CPU/memory usage

---

## 📈 Results Achieved

- Automated deployments triggered on every Git push
- Full application monitoring with real-time dashboards
- Zero-downtime deployments using Docker rolling updates
- Automated alerts when application health degrades

---

## 🖼️ Screenshots

### Jenkins Pipeline
![Jenkins Pipeline](screenshots/jenkins-pipeline.png)

### Grafana Dashboard
![Grafana Dashboard](screenshots/grafana-dashboard.png)

---

## 👤 Author

**Rishikesh Rawate** — DevOps Engineer
📧 rawaterishikesh@gmail.com
🔗 [LinkedIn](https://linkedin.com/in/YOUR-LINKEDIN)
🐙 [GitHub](https://github.com/Rishis-hub)
