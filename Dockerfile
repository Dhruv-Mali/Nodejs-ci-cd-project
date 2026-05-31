# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build application
RUN npm run build --if-present

# Production stage
FROM node:18-alpine

WORKDIR /app

# Install dumb-init to handle signals properly
RUN apk add --no-cache dumb-init

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --production

# Copy built application from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/build ./build
COPY --from=builder /app/public ./public

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/message', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Expose port
EXPOSE 3000

# Use dumb-init to ensure signals are handled correctly
ENTRYPOINT ["dumb-init", "--"]

# Start application
CMD ["npm", "start"]