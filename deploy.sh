#!/bin/bash

# WEXA AI Assignment - Kubernetes Deployment Script
# Make sure to replace <YOUR_GITHUB_USERNAME> with your actual GitHub username

echo "🚀 WEXA AI Assignment - Kubernetes Deployment"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed or not in PATH${NC}"
    exit 1
fi

# Check if minikube is available
if ! command -v minikube &> /dev/null; then
    echo -e "${RED}❌ minikube is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Before proceeding, make sure you have:${NC}"
echo "1. Updated k8s/deployment.yaml with your GitHub username"
echo "2. Created GHCR secret if your package is private"
echo ""

read -p "Have you completed the above steps? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Please complete the setup steps first.${NC}"
    echo ""
    echo "To create GHCR secret (if package is private):"
    echo "kubectl create secret docker-registry ghcr-secret \\"
    echo "  --docker-server=ghcr.io \\"
    echo "  --docker-username=<YOUR_GITHUB_USERNAME> \\"
    echo "  --docker-password=<YOUR_PERSONAL_ACCESS_TOKEN> \\"
    echo "  --docker-email=<YOUR_EMAIL>"
    exit 1
fi

echo -e "${GREEN}🔄 Deploying to Kubernetes...${NC}"

# Apply Kubernetes manifests
echo "Applying deployment..."
kubectl apply -f k8s/deployment.yaml

echo "Applying service..."
kubectl apply -f k8s/service.yaml

echo -e "${GREEN}✅ Deployment completed!${NC}"
echo ""

# Wait a moment for pods to start
echo "Waiting for pods to start..."
sleep 5

# Show status
echo -e "${YELLOW}📊 Current Status:${NC}"
echo "Pods:"
kubectl get pods -l app=nextjs-app

echo ""
echo "Services:"
kubectl get svc nextjs-service

echo ""
echo "Deployment:"
kubectl get deploy nextjs-app

echo ""
echo -e "${GREEN}🌐 Access your application:${NC}"
MINIKUBE_IP=$(minikube ip 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "Minikube IP: $MINIKUBE_IP"
    echo "Application URL: http://$MINIKUBE_IP:30080"
else
    echo "Run 'minikube ip' to get the cluster IP"
    echo "Then access: http://<MINIKUBE_IP>:30080"
fi

echo ""
echo "Or use: minikube service nextjs-service --url"

echo ""
echo -e "${YELLOW}🔍 Useful debugging commands:${NC}"
echo "kubectl get pods"
echo "kubectl logs deployment/nextjs-app"
echo "kubectl describe pod <pod-name>"
echo "kubectl rollout status deployment/nextjs-app"
