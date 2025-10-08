# WEXA AI Assignment - Next.js App with CI/CD and Kubernetes Deployment

This project demonstrates a Next.js application with automated CI/CD pipeline using GitHub Actions and deployment to Kubernetes/Minikube using GitHub Container Registry (GHCR).

## 🚀 GHCR Image

**Container Image:** `ghcr.io/mohanty2003/devops_assignment_wexa_ai:latest`

## 📋 Prerequisites

- Docker
- Minikube
- kubectl
- GitHub Personal Access Token with `packages:write` and `packages:read` permissions

## 🔧 Setup Instructions

### 1. GitHub Container Registry Access

If your GHCR package is private, create a Kubernetes secret for image pulling:

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<YOUR_GITHUB_USERNAME> \
  --docker-password=<YOUR_PERSONAL_ACCESS_TOKEN> \
  --docker-email=<YOUR_EMAIL>
```

### 2. Deploy to Minikube

Before deploying, update the image reference in `k8s/deployment.yaml`:
- Replace `<YOUR_GITHUB_USERNAME>` with your actual GitHub username

```bash
# Apply the Kubernetes manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### 3. Access the Application

```bash
# Get Minikube IP
minikube ip

# The service uses NodePort 30080, so access via:
# http://<MINIKUBE_IP>:30080

# Or use Minikube service command
minikube service nextjs-service --url
```

## 🔍 Verification Commands

### Check Deployment Status
```bash
kubectl get pods
kubectl get svc
kubectl get deploy
kubectl rollout status deployment/nextjs-app
```

### Debugging Commands
```bash
# Describe pod for detailed information
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
# or
kubectl logs deployment/nextjs-app

# Watch rollout
kubectl rollout status deployment/nextjs-app
```

### Common Issues and Solutions

**ImagePullBackOff Error:**
- Ensure GHCR secret is created and referenced in deployment
- Check if the image exists and is accessible
- Verify Personal Access Token permissions

**Container Crashes:**
```bash
kubectl logs <pod-name>
```

### Update to New Image Version
```bash
kubectl set image deployment/nextjs-app nextjs=ghcr.io/<YOUR_GITHUB_USERNAME>/wexa_ai_assignment:<new-tag>
kubectl rollout status deployment/nextjs-app
```

## 🏗️ CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci.yml`) automatically:
1. Builds the Docker image
2. Pushes to GitHub Container Registry
3. Tags with both `latest` and commit SHA

## 📁 Project Structure

```
.
├── ci.yml                 # GitHub Actions workflow
├── Dockerfile            # Container build instructions
├── README.md             # This file
├── app/                  # Next.js application
│   ├── next.config.js
│   ├── package.json
│   └── pages/
│       ├── index.js
│       └── api/
└── k8s/                  # Kubernetes manifests
    ├── deployment.yaml   # App deployment
    └── service.yaml      # NodePort service
```

## 🎯 Deployment Verification

After successful deployment, you should see:
- 2 running pods: `kubectl get pods`
- Service accessible via NodePort: `kubectl get svc`
- Application responding at the Minikube IP on port 30080

## 📸 Screenshots

screenshots:
<img width="658" height="238" alt="image" src="https://github.com/user-attachments/assets/1f1b2fbf-9bb3-490b-8834-2cc5add6b619" />
![png (4)](https://github.com/user-attachments/assets/999315f8-d02d-42eb-99e2-17bbeb3ac5f9)
