#!/bin/bash
set -e

# Set default values if not provided
export REDIS_PASSWORD=${REDIS_PASSWORD:-difyai123456}
export SERVER_WORKER_AMOUNT=${SERVER_WORKER_AMOUNT:-1}
export SERVER_WORKER_CLASS=${SERVER_WORKER_CLASS:-gevent}
export GUNICORN_TIMEOUT=${GUNICORN_TIMEOUT:-360}
export PM2_INSTANCES=${PM2_INSTANCES:-2}
export CELERY_QUEUES=${CELERY_QUEUES:-dataset,generation,mail,ops_trace,app_deletion}

# Set Redis connection for local Redis
export REDIS_HOST=${REDIS_HOST:-127.0.0.1}
export REDIS_PORT=${REDIS_PORT:-6379}
export CELERY_BROKER_URL="redis://:${REDIS_PASSWORD}@${REDIS_HOST}:${REDIS_PORT}/1"

# Database configuration
export DB_HOST=${DB_HOST:-${CAPROVER_POSTGRES_HOST:-postgres}}
export DB_PORT=${DB_PORT:-5432}
export DB_USERNAME=${DB_USERNAME:-postgres}
export DB_PASSWORD=${DB_PASSWORD:-difyai123456}
export DB_DATABASE=${DB_DATABASE:-dify}

# API URLs configuration (baseado na documentação oficial)
export CONSOLE_API_URL=${CONSOLE_API_URL:-}
export CONSOLE_WEB_URL=${CONSOLE_WEB_URL:-}
export SERVICE_API_URL=${SERVICE_API_URL:-}
export APP_API_URL=${APP_API_URL:-}
export APP_WEB_URL=${APP_WEB_URL:-}

# Frontend específico (Next.js)
export NEXT_PUBLIC_API_PREFIX=${CONSOLE_API_URL}/console/api
export NEXT_PUBLIC_PUBLIC_API_PREFIX=${SERVICE_API_URL}/api
export NEXT_PUBLIC_DEPLOY_ENV=PRODUCTION
export NEXT_PUBLIC_EDITION=SELF_HOSTED

# Files URL configuration
export FILES_URL=${FILES_URL:-}
export INTERNAL_FILES_URL=${INTERNAL_FILES_URL:-http://127.0.0.1:5001}

# Secret key - generate if not provided
if [ -z "$SECRET_KEY" ]; then
    export SECRET_KEY=$(openssl rand -base64 42)
    echo "Generated SECRET_KEY: $SECRET_KEY"
fi

# Storage configuration
export STORAGE_TYPE=${STORAGE_TYPE:-local}
export UPLOAD_FILE_SIZE_LIMIT=${UPLOAD_FILE_SIZE_LIMIT:-15}
export UPLOAD_FILE_BATCH_LIMIT=${UPLOAD_FILE_BATCH_LIMIT:-5}

# Vector store configuration
export VECTOR_STORE=${VECTOR_STORE:-weaviate}

# If using external PostgreSQL, wait for it to be ready
if [ "$DB_HOST" != "127.0.0.1" ] && [ "$DB_HOST" != "localhost" ]; then
    echo "Waiting for PostgreSQL to be ready..."
    until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USERNAME; do
        echo "PostgreSQL is not ready yet..."
        sleep 2
    done
    echo "PostgreSQL is ready!"
fi

# Run migrations if enabled
if [ "$MIGRATION_ENABLED" = "true" ]; then
    echo "Running database migrations..."
    cd /app/api
    flask db upgrade
    echo "Migrations completed!"
fi

# Start supervisor
echo "Starting Dify services with supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/dify.conf
