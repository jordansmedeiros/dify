#!/bin/bash
set -e

echo "🚀 Iniciando Dify MONOLÍTICO (TODOS os serviços incluídos)"

# Set default values
export REDIS_PASSWORD=${REDIS_PASSWORD:-difyai123456}
export SERVER_WORKER_AMOUNT=${SERVER_WORKER_AMOUNT:-1}
export SERVER_WORKER_CLASS=${SERVER_WORKER_CLASS:-gevent}
export GUNICORN_TIMEOUT=${GUNICORN_TIMEOUT:-360}
export PM2_INSTANCES=${PM2_INSTANCES:-2}
export CELERY_QUEUES=${CELERY_QUEUES:-dataset,generation,mail,ops_trace,app_deletion}
export SANDBOX_API_KEY=${SANDBOX_API_KEY:-dify-sandbox}
export WEAVIATE_API_KEY=${WEAVIATE_API_KEY:-WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih}

# Database configuration (apenas PostgreSQL externo)
export DB_HOST=${DB_HOST:-srv-captain--postgres-dify}
export DB_PORT=${DB_PORT:-5432}
export DB_USERNAME=${DB_USERNAME:-postgres}
export DB_PASSWORD=${DB_PASSWORD:-difyai123456}
export DB_DATABASE=${DB_DATABASE:-dify}

# Redis configuration (LOCAL - dentro do container)
export REDIS_HOST=127.0.0.1
export REDIS_PORT=6379
export REDIS_DB=0
export CELERY_BROKER_URL="redis://:${REDIS_PASSWORD}@127.0.0.1:6379/1"

# Weaviate configuration (LOCAL - dentro do container)
export WEAVIATE_ENDPOINT=http://127.0.0.1:8080
export VECTOR_STORE=weaviate

# Sandbox configuration (LOCAL - dentro do container)
export CODE_EXECUTION_ENDPOINT=http://127.0.0.1:8194
export CODE_EXECUTION_API_KEY=${SANDBOX_API_KEY}

# SSRF Proxy configuration (LOCAL - dentro do container)
export SSRF_PROXY_HTTP_URL=http://127.0.0.1:3128
export SSRF_PROXY_HTTPS_URL=http://127.0.0.1:3128

# URLs configuration
export CONSOLE_API_URL=${CONSOLE_API_URL:-}
export CONSOLE_WEB_URL=${CONSOLE_WEB_URL:-}
export SERVICE_API_URL=${SERVICE_API_URL:-}
export APP_API_URL=${APP_API_URL:-}
export APP_WEB_URL=${APP_WEB_URL:-}
export FILES_URL=${FILES_URL:-}
export INTERNAL_FILES_URL=http://127.0.0.1:5001

# Frontend específico (Next.js)
export NEXT_PUBLIC_API_PREFIX=${CONSOLE_API_URL}/console/api
export NEXT_PUBLIC_PUBLIC_API_PREFIX=${SERVICE_API_URL}/api
export NEXT_PUBLIC_DEPLOY_ENV=PRODUCTION
export NEXT_PUBLIC_EDITION=SELF_HOSTED

# Security
export SECRET_KEY=${SECRET_KEY:-sk-please-change-this-key}

# Basic settings
export STORAGE_TYPE=${STORAGE_TYPE:-local}
export MIGRATION_ENABLED=${MIGRATION_ENABLED:-true}
export DEPLOY_ENV=${DEPLOY_ENV:-PRODUCTION}

# Plugin daemon configuration
export PLUGIN_DAEMON_PORT=5002
export PLUGIN_DAEMON_KEY=${PLUGIN_DAEMON_KEY:-lYkiYYT6owG+71oLerGzA7GXCgOT++6ovaezWAjpCjf+Sjc3ZtU+qUEi}
export PLUGIN_DIFY_INNER_API_KEY=${PLUGIN_DIFY_INNER_API_KEY:-QaHbTe77CtuXmsfyhR7+vRjI/+XbV1AaFy691iy+kGDv2Jvy0/eAh8Y1}
export PLUGIN_DIFY_INNER_API_URL=http://127.0.0.1:5001

# Wait for external PostgreSQL
if [ "$DB_HOST" != "127.0.0.1" ] && [ "$DB_HOST" != "localhost" ]; then
    echo "⏳ Aguardando PostgreSQL ($DB_HOST:$DB_PORT)..."
    until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USERNAME; do
        echo "PostgreSQL ainda não está pronto..."
        sleep 2
    done
    echo "✅ PostgreSQL está pronto!"
fi

# Run migrations
if [ "$MIGRATION_ENABLED" = "true" ]; then
    echo "🔄 Executando migrações do banco..."
    cd /app/api
    flask db upgrade
    echo "✅ Migrações completadas!"
fi

echo "🚀 Iniciando TODOS os serviços do Dify:"
echo "  🔴 Redis (interno:6379)"
echo "  🧠 Weaviate (interno:8080)" 
echo "  🛡️ SSRF Proxy (interno:3128)"
echo "  🏗️ Sandbox (interno:8194)"
echo "  ⚙️ API (0.0.0.0:5001)"
echo "  👷 Celery Workers"
echo "  ⏰ Celery Beat"
echo "  🌐 Frontend Next.js (interno:3000)"

# Start supervisor with ALL services
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/dify.conf
