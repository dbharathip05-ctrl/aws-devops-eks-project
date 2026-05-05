// app/server.js
// Simple Express web app — SonarQube will scan this, Jenkins will build it

const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Main page — shows what tools were used
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>DevOps Platform — Divya Bharathi</title>
      <style>
        body { font-family: Arial, sans-serif; background: #0D1117;
               color: #E6EDF3; padding: 2rem; max-width: 700px; margin: auto; }
        h1   { color: #58A6FF; }
        .tag { display: inline-block; background: #21262D; border-radius: 4px;
               padding: 2px 8px; margin: 3px; font-size: 13px; color: #79C0FF; }
        .ok  { color: #56D364; }
      </style>
    </head>
    <body>
      <h1>🚀 AWS DevOps EKS Platform</h1>
      <p><strong>by Divya Bharathi Prasannakumar</strong></p>
      <p>Deployed with:</p>
      <span class="tag ok">✅ Terraform</span>
      <span class="tag ok">✅ AWS EKS</span>
      <span class="tag ok">✅ Jenkins CI/CD</span>
      <span class="tag ok">✅ SonarQube</span>
      <span class="tag ok">✅ Docker + ECR</span>
      <span class="tag ok">✅ Helm</span>
      <span class="tag ok">✅ Nginx Ingress</span>
      <br/><br/>
      <p style="color:#8B949E; font-size: 13px;">
        Region: ap-south-1 (Mumbai) &nbsp;|&nbsp;
        Version: ${process.env.APP_VERSION || 'local'} &nbsp;|&nbsp;
        Pod: ${process.env.HOSTNAME || 'localhost'}
      </p>
    </body>
    </html>
  `);
});

// Health check — Kubernetes hits this every 30s to check the app is alive
app.get('/health', (req, res) => {
  res.json({
    status:    'healthy',
    timestamp: new Date().toISOString(),
    version:   process.env.APP_VERSION || 'local',
    region:    'ap-south-1'
  });
});

app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});
