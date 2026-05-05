#!/bin/bash
# scripts/setup-eks-access.sh
# Run AFTER terraform apply creates your cluster
# This connects kubectl to your EKS cluster

AWS_ACCOUNT="051797965283"
CLUSTER_NAME="divya-eks-cluster"
REGION="ap-south-1"
ECR_URL="${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/divya-app"

echo "🔌 Connecting kubectl to EKS cluster: ${CLUSTER_NAME}"
aws eks update-kubeconfig \
    --name "${CLUSTER_NAME}" \
    --region "${REGION}"

echo "📋 Checking cluster nodes (should show 2 nodes Ready):"
kubectl get nodes -o wide

echo ""
echo "📦 Installing Nginx Ingress Controller..."
helm install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --create-namespace \
    --set controller.replicaCount=2

echo "⏳ Waiting for ingress controller to start..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo ""
echo "🌐 Ingress external IP (copy this URL to test your app):"
kubectl get svc -n ingress-nginx ingress-nginx-controller

echo ""
echo "🔑 Login to ECR for Docker push:"
aws ecr get-login-password --region ${REGION} | \
    docker login --username AWS --password-stdin ${ECR_URL}

echo ""
echo "════════════════════════════════════════"
echo "✅ EKS cluster ready!"
echo "ECR URL: ${ECR_URL}"
echo "Cluster: ${CLUSTER_NAME}"
echo "Region:  ${REGION}"
echo "════════════════════════════════════════"
