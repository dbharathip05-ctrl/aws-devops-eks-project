# Multi-stage build for Node.js application
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Runtime stage
FROM node:18-alpine
WORKDIR /app
RUN addgroup -g 1001 appuser && adduser -D -u 1001 -G appuser appuser

COPY --from=builder /app/node_modules ./node_modules
COPY --chown=appuser:appuser . .

EXPOSE 3000
USER appuser

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => r.statusCode === 200 ? process.exit(0) : process.exit(1))"

CMD ["node", "server.js"]
