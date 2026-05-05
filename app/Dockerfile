# app/Dockerfile
# Builds your Node.js app into a Docker container image

FROM node:18-alpine

# Set working directory inside the container
WORKDIR /app

# Copy package files and install dependencies
# (do this BEFORE copying source — Docker caches this layer)
COPY package*.json ./
RUN npm install --production

# Copy the rest of the application code
COPY . .

# The port your app listens on
EXPOSE 3000

# Health check — tells Docker and Kubernetes if the app is running
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q http://localhost:3000/health -O- || exit 1

# Start the app
CMD ["node", "server.js"]
