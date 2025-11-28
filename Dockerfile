# --------------------------
# STAGE 1: Build Angular App
# --------------------------
FROM node:18 AS frontend-build

WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# --------------------------
# STAGE 2: Setup Backend
# --------------------------
FROM node:18 AS backend-build

WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ .

# --------------------------
# STAGE 3: Final Image with Nginx + Node
# --------------------------
FROM nginx:alpine

# Copy Angular build to Nginx
COPY --from=frontend-build /app/frontend/dist /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy backend
COPY --from=backend-build /app/backend /app/backend

# Install Node runtime
RUN apk add --no-cache nodejs npm

# Expose port 80 for Nginx
EXPOSE 80

# Start both backend & Nginx
CMD node /app/backend/server.js & nginx -g 'daemon off;'
