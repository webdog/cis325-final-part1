FROM python:3.11.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    gcc \
    libpcre3-dev \
    curl \
    nginx \
    && apt-get clean


# Install Poetry
RUN pip install poetry

# Copy application files
COPY . /app

COPY config/uwsgi.ini /app/uwsgi.ini
COPY config/nginx.conf /etc/nginx/nginx.conf

# Install dependencies using Poetry
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi --no-root --without dev,macos

# Expose port 80
EXPOSE 80

# Start both uWSGI and Nginx
CMD ["/bin/sh", "-c", "uwsgi --ini /app/uwsgi.ini & nginx -g 'daemon off;'"]