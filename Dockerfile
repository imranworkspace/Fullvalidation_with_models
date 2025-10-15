# Dockerfile

# Base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /formvalidation_with__model

# Install dependencies
COPY requirnments.txt /formvalidation_with__model/
RUN pip install --upgrade pip
RUN pip install -r requirnments.txt


# Copy project files
COPY . /formvalidation_with__model/

# Copy entrypoint.sh
COPY entrypoint.sh /entrypoint.sh

# Give execute permissions
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]