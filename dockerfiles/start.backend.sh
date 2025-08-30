#!/bin/bash
set -e

echo "🛡️ Iniciando Dify Backend (API + Workers + Sandbox + Plugin Daemon)"

# Set default values
export REDIS_PASSWORD=${REDIS_PASSWORD:-}
export SERVER_WORKER_AMOUNT=${SERVER_WORKER_AMOUNT:-1}
export SERVER_WORKER_CLASS=${SERVER_WORKER_CLASS:-gevent}
export GUNICORN_TIMEOUT=${GUNICORN_TIMEOUT:-360}
export CELERY_QUEUES=${CELERY_QUEUES:-dataset,generation,mail,ops_trace,app_deletion}
export SANDBOX_API_KEY=${SANDBOX_API_KEY:-dify-sandbox}

# Database configuration
export DB_HOST=${DB_HOST:-srv-captain--postgres-dify}
export DB_PORT=${DB_PORT:-5432}
export DB_USERNAME=${DB_USERNAME:-postgres}
export DB_PASSWORD=${DB_PASSWORD:-difyai123456}
export DB_DATABASE=${DB_DATABASE:-dify}

# Redis configuration (externo CapRover)
export REDIS_HOST=${REDIS_HOST:-srv-captain--redis-dify}
export REDIS_PORT=${REDIS_PORT:-6379}
export REDIS_DB=${REDIS_DB:-0}
export CELERY_BROKER_URL="redis://:${REDIS_PASSWORD}@${REDIS_HOST}:${REDIS_PORT}/1"

# Weaviate configuration (externo CapRover)
export WEAVIATE_ENDPOINT=${WEAVIATE_ENDPOINT:-http://srv-captain--weaviate-dify:8080}
export WEAVIATE_API_KEY=${WEAVIATE_API_KEY:-WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih}

# Sandbox configuration (local neste container)
export CODE_EXECUTION_ENDPOINT=http://127.0.0.1:8194
export CODE_EXECUTION_API_KEY=${SANDBOX_API_KEY}

# SSRF Proxy configuration (local neste container)
export SSRF_PROXY_HTTP_URL=http://127.0.0.1:3128
export SSRF_PROXY_HTTPS_URL=http://127.0.0.1:3128

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

# Plugin daemon configuration
export PLUGIN_DAEMON_PORT=${PLUGIN_DAEMON_PORT:-5002}
export PLUGIN_DAEMON_KEY=${PLUGIN_DAEMON_KEY:-lYkiYYT6owG+71oLerGzA7GXCgOT++6ovaezWAjpCjf+Sjc3ZtU+qUEi}
export PLUGIN_DIFY_INNER_API_KEY=${PLUGIN_DIFY_INNER_API_KEY:-QaHbTe77CtuXmsfyhR7+vRjI/+XbV1AaFy691iy+kGDv2Jvy0/eAh8Y1}
export PLUGIN_DIFY_INNER_API_URL=http://127.0.0.1:5001

# Wait for external services
echo "⏳ Aguardando serviços externos..."

# Wait for PostgreSQL
if [ "$DB_HOST" != "127.0.0.1" ] && [ "$DB_HOST" != "localhost" ]; then
    echo "⏳ Aguardando PostgreSQL ($DB_HOST:$DB_PORT)..."
    until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USERNAME; do
        echo "PostgreSQL ainda não está pronto..."
        sleep 2
    done
    echo "✅ PostgreSQL está pronto!"
fi

# Test Redis connection
if [ "$REDIS_HOST" != "127.0.0.1" ] && [ "$REDIS_HOST" != "localhost" ]; then
    echo "⏳ Testando Redis ($REDIS_HOST:$REDIS_PORT)..."
    until timeout 5 bash -c "</dev/tcp/$REDIS_HOST/$REDIS_PORT"; do
        echo "Redis ainda não está acessível..."
        sleep 2
    done
    echo "✅ Redis está acessível!"
fi

# Test Weaviate connection
if [ ! -z "$WEAVIATE_ENDPOINT" ]; then
    WEAVIATE_HOST=$(echo $WEAVIATE_ENDPOINT | sed 's|http://||' | sed 's|:.*||')
    WEAVIATE_PORT=$(echo $WEAVIATE_ENDPOINT | sed 's|.*:||')
    echo "⏳ Testando Weaviate ($WEAVIATE_HOST:$WEAVIATE_PORT)..."
    until timeout 5 bash -c "</dev/tcp/$WEAVIATE_HOST/$WEAVIATE_PORT"; do
        echo "Weaviate ainda não está acessível..."
        sleep 2
    done
    echo "✅ Weaviate está acessível!"
fi

# Run migrations
if [ "$MIGRATION_ENABLED" = "true" ]; then
    echo "🔄 Executando migrações do banco..."
    cd /app/api
    flask db upgrade
    echo "✅ Migrações completadas!"
fi

# Start supervisor with all backend services
echo "🚀 Iniciando todos os serviços do backend..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/dify.conf
