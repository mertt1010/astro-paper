# Base stage for building the static files
FROM node:lts-alpine AS base
WORKDIR /app

# Install pnpm globally (böylece corepack hatası almazsınız)
RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm run build

# Runtime stage for serving the application
FROM nginx:mainline-alpine-slim AS runtime
COPY --from=base /app/dist /usr/share/nginx/html
EXPOSE 80