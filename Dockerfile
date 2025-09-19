# Use official Python image
FROM python:3.13-slim

# Prevent Python from writing .pyc files & make stdout/stderr unbuffered
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system deps for Pillow, database adapters, etc.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        libjpeg-dev \
        zlib1g-dev \
        libpng-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt /app/
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt

# Copy entire project
COPY . /app/

# Expose port (adjust if your app uses a different port)
EXPOSE 8000

# Default entrypoint: run Django dev server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
