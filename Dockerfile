# Dockerfile
FROM python:3.9-slim

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y build-essential libpq-dev curl netcat && \
    rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app/

# Optional: Create static folder to remove warnings
RUN mkdir -p /app/static

# Optional: Collect static files at build time
# RUN python manage.py collectstatic --noinput

# Add wait-for-db script for CI/CD pipelines
COPY wait-for-db.sh /app/
RUN chmod +x /app/wait-for-db.sh

# Default command: wait for DB, apply migrations, then run Gunicorn
CMD ["/bin/sh", "-c", "./wait-for-db.sh && python manage.py migrate --noinput && gunicorn formvalidation_with__model.wsgi:application --bind 0.0.0.0:8010"]
