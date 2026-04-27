# Zero Downtime SaaS Deployment (Blue-Green + Auto Rollback)

## Project Overview
This project demonstrates a **production-grade zero downtime deployment system** using:

- Dockerized application (PHP + Apache)
- Blue-Green deployment strategy
- NGINX as reverse proxy
- CI/CD using GitHub Actions
- Automated rollback on failure
- Monitoring using Prometheus & Grafana

---

## Architecture Diagram
            ┌──────────────┐
            │   GitHub     │
            │ (Code Push)  │
            └──────┬───────┘
                   │
                   ▼
        ┌─────────────────────┐
        │ GitHub Actions CI/CD│
        │  - Build Docker     │
        │  - Security Scan    │
        │  - Deploy via SSH   │
        └────────┬────────────┘
                 │
                 ▼
     ┌──────────────────────────┐
     │        EC2 Server        │
     │                          │
     │   ┌───────────────┐      │
     │   │   NGINX       │◄────────────── User Traffic
     │   │ Reverse Proxy │      │
     │   └──────┬────────┘      │
     │          │               │
     │   ┌──────▼──────┐        │
     │   │ Blue App    │ (8081) │
     │   └─────────────┘        │
     │   ┌─────────────┐        │
     │   │ Green App   │ (8082) │
     │   └─────────────┘        │
     │                          │
     │ Monitoring Stack         │
     │ Prometheus + Grafana     │
     └──────────────────────────┘



---

## Key Features

### Zero Downtime Deployment
- Blue-Green deployment strategy
- Instant traffic switch via NGINX

### Automated Rollback
- Health check validation before traffic switch
- Automatic rollback if deployment fails

### CI/CD Pipeline
- Triggered on every push
- Docker image build
- Vulnerability scanning using Trivy
- Automated deployment to EC2

### Monitoring & Alerts
- Prometheus for metrics collection
- Grafana dashboards
- Alerting via SMTP (email notifications)

### Security
- Container vulnerability scanning
- Secure SSH-based deployment

---

## Deployment Flow

1. Developer pushes code to GitHub
2. GitHub Actions triggers CI pipeline
3. Docker image is built
4. Trivy scans for vulnerabilities
5. Deployment script runs on EC2
6. New version deployed to **inactive environment**
7. Health check is performed
8. If successful:
   - NGINX switches traffic
9. If failed:
   - Rollback to previous version

---

## Rollback Mechanism

- New version is deployed on inactive port
- Health check validates application
- If health check fails:
  - New container is stopped
  - NGINX continues serving old version
  - System logs failure in `deploy.log`

---

## Tech Stack

- **Cloud:** AWS EC2  
- **CI/CD:** GitHub Actions  
- **Containerization:** Docker  
- **Web Server:** NGINX + Apache (PHP)  
- **Monitoring:** Prometheus, Grafana  
- **Security:** Trivy  

---

## Project Structure

zero-downtime-saas-deployment/
│
├── app/ # Application code (PHP site)
├── scripts/ # Deployment scripts
│ └── deploy.sh
├── .github/workflows/ # CI/CD pipeline
├── monitoring/ # Prometheus & Grafana configs
└── README.md


---

## 🧪 Failure Testing

- Simulated deployment failure
- Health check failure triggers rollback
- Verified zero downtime during failure

---

## Key Learnings

- Blue-Green deployment in real-world setup
- CI/CD pipeline design
- Handling production failures
- Monitoring & alerting setup
- Debugging real DevOps issues (permissions, pipelines)

---

## Future Improvements

- Kubernetes migration
- Load balancer integration (ALB)
- Auto-scaling
- NGINX + PHP-FPM separation
- Secrets management

---

## Author

**Subha Sankar Das**

---

## ⭐ Conclusion

This project demonstrates a **production-ready deployment architecture** with:

- High availability
- Zero downtime
- Self-healing capability

---