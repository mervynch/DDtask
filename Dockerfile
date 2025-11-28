# Stage 1: Build Angular
FROM node:18 AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# Stage 2: Setup Nginx
FROM nginx:alpine
# <-- COPY Angular build to Nginx
COPY --from=frontend-build /app/frontend/dist/<app-name> /usr/share/nginx/html

# Copy your nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
