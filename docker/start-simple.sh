#!/bin/bash
set -e

echo "🚀 Iniciando Dify API simplificada..."

# Database configuration
export DB_HOST=${DB_HOST:-postgres}
export DB_PORT=${DB_PORT:-5432}
export DB_USERNAME=${DB_USERNAME:-postgres}
export DB_PASSWORD=${DB_PASSWORD:-difyai123456}
export DB_DATABASE=${DB_DATABASE:-dify}

# Redis configuration (assumindo Redis externo do CapRover)
export REDIS_HOST=${REDIS_HOST:-srv-captain--redis}
export REDIS_PORT=${REDIS_PORT:-6379}
export REDIS_PASSWORD=${REDIS_PASSWORD:-}
export REDIS_DB=${REDIS_DB:-0}
export CELERY_BROKER_URL="redis://:${REDIS_PASSWORD}@${REDIS_HOST}:${REDIS_PORT}/1"

# URLs configuration
export CONSOLE_API_URL=${CONSOLE_API_URL:-}
export CONSOLE_WEB_URL=${CONSOLE_WEB_URL:-}
export SERVICE_API_URL=${SERVICE_API_URL:-}
export APP_API_URL=${APP_API_URL:-}
export APP_WEB_URL=${APP_WEB_URL:-}
export FILES_URL=${FILES_URL:-}
export INTERNAL_FILES_URL=${INTERNAL_FILES_URL:-http://127.0.0.1:5001}

# Security
export SECRET_KEY=${SECRET_KEY:-sk-please-change-this-key}

# Basic settings
export VECTOR_STORE=${VECTOR_STORE:-weaviate}
export STORAGE_TYPE=${STORAGE_TYPE:-local}
export MIGRATION_ENABLED=${MIGRATION_ENABLED:-true}

# Wait for PostgreSQL
if [ "$DB_HOST" != "127.0.0.1" ] && [ "$DB_HOST" != "localhost" ]; then
    echo "⏳ Aguardando PostgreSQL estar pronto..."
    until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USERNAME; do
        echo "PostgreSQL ainda não está pronto..."
        sleep 2
    done
    echo "✅ PostgreSQL está pronto!"
fi

# Run migrations
if [ "$MIGRATION_ENABLED" = "true" ]; then
    echo "🔄 Executando migrações do banco..."
    flask db upgrade
    echo "✅ Migrações completadas!"
fi

# Start API server
echo "🎯 Iniciando servidor API na porta 5001..."
exec gunicorn \
    --bind 0.0.0.0:5001 \
    --workers ${SERVER_WORKER_AMOUNT:-1} \
    --worker-class ${SERVER_WORKER_CLASS:-gevent} \
    --timeout ${GUNICORN_TIMEOUT:-360} \
    --preload \
    --access-logfile - \
    --error-logfile - \
    app:app
