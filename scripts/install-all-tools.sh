#!/bin/bash
# scripts/install-all-tools.sh
# Run this on your Jenkins EC2 server after SSH-ing in
# Command: sudo bash scripts/install-all-tools.sh

set -e   # stop if any command fails
echo "🚀 Installing all DevOps tools — AWS Account: 051797965283, Region: ap-south-1"

# ── 1. AWS CLI ─────────────────────────────────────────────────────
echo "📦 Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install -y unzip
unzip -q awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip
echo "✅ AWS CLI: $(aws --version)"

# ── 2. kubectl ────────────────────────────────────────────────────
echo "📦 Installing kubectl..."
KUBECTL_VER=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
curl -Lo kubectl \
  "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VER}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
echo "✅ kubectl: $(kubectl version --client --short)"

# ── 3. eksctl ─────────────────────────────────────────────────────
echo "📦 Installing eksctl..."
curl --silent --location \
  "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
  | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/eksctl
echo "✅ eksctl: $(eksctl version)"

# ── 4. Helm ───────────────────────────────────────────────────────
echo "📦 Installing Helm..."
curl -O https://get.helm.sh/helm-v3.16.2-linux-amd64.tar.gz
tar xvf helm-v3.16.2-linux-amd64.tar.gz -C /tmp
sudo mv /tmp/linux-amd64/helm /usr/local/bin/helm
rm -f helm-v3.16.2-linux-amd64.tar.gz
echo "✅ Helm: $(helm version --short)"

# ── 5. Docker ─────────────────────────────────────────────────────
echo "📦 Installing Docker..."
apt update
apt install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
usermod -aG docker jenkins 2>/dev/null || true
echo "✅ Docker: $(docker --version)"

# ── 6. Java (required by Jenkins) ─────────────────────────────────
echo "📦 Installing Java 17..."
apt install -y fontconfig openjdk-17-jre
echo "✅ Java: $(java -version 2>&1 | head -1)"

# ── 7. Add Helm repos ─────────────────────────────────────────────
echo "📦 Adding Helm repositories..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
echo "✅ Helm repos added"

# ── 8. Create kubeconfig directory for Jenkins ────────────────────
mkdir -p /opt/kube
chown -R jenkins:jenkins /opt/kube/ 2>/dev/null || true
mkdir -p /opt/docker

echo ""
echo "════════════════════════════════════════"
echo "✅ ALL TOOLS INSTALLED SUCCESSFULLY!"
echo "════════════════════════════════════════"
echo ""
echo "NEXT STEP — Configure AWS CLI:"
echo "  aws configure"
echo "  Enter: Access Key ID"
echo "  Enter: Secret Access Key"
echo "  Enter region: ap-south-1"
echo "  Enter format: json"
echo ""
echo "NEVER share your Access Key or Secret Key with anyone!"
