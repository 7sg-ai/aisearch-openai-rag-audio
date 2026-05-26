# Stage 1: Build the Vite app
FROM node:20-slim AS build-stage

WORKDIR /build
COPY frontend ./
WORKDIR /build
RUN npm install
RUN npm run build

# Stage 2: Production
FROM python:3.12-slim AS production-stage

WORKDIR /app

# Copy static files from build stage
COPY --from=build-stage /build/dist /app/static

# Copy backend code
COPY backend/ /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV RUNNING_IN_PRODUCTION=true

RUN python -m pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["python3", "-m", "gunicorn", "app:create_app", "-b", "0.0.0.0:8080", "--worker-class", "aiohttp.GunicornWebWorker"]
