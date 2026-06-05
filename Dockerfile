FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV PYTHONUNBUFFERED=1
EXPOSE 8080
RUN pip install opentelemetry-distro opentelemetry-exporter-otlp-proto-http
CMD ["opentelemetry-instrument", "python", "main.py"]
