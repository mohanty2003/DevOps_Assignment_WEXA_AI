# --- Build stage ---
FROM node:18-alpine AS builder
WORKDIR /app


# install dependencies
COPY app/package.json ./
COPY app/package-lock.json* ./
RUN apk add --no-cache python3 make g++ || true
RUN npm ci --silent || npm install

# copy source files
COPY app/ ./

# build the application
RUN npm run build


# --- Production image ---
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup


# copy only what we need
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
# Copy public directory if it exists and has content
COPY --from=builder /app/public ./public


# expose port
ENV PORT=3000
EXPOSE 3000
USER appuser


# Start the app
CMD ["npm", "run", "start"]