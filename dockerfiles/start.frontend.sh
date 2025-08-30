#!/bin/sh
set -e

echo "🌐 Iniciando Dify Frontend (Next.js)"

# Frontend configuration based on official docs
export NEXT_PUBLIC_API_PREFIX=${CONSOLE_API_URL}/console/api
export NEXT_PUBLIC_PUBLIC_API_PREFIX=${APP_API_URL}/api
export NEXT_PUBLIC_DEPLOY_ENV=PRODUCTION
export NEXT_PUBLIC_EDITION=SELF_HOSTED

# Runtime configuration
export CONSOLE_API_URL=${CONSOLE_API_URL:-}
export APP_API_URL=${APP_API_URL:-}
export SENTRY_DSN=${WEB_SENTRY_DSN:-}
export NEXT_TELEMETRY_DISABLED=1
export TEXT_GENERATION_TIMEOUT_MS=${TEXT_GENERATION_TIMEOUT_MS:-60000}
export CSP_WHITELIST=${CSP_WHITELIST:-}
export ALLOW_EMBED=${ALLOW_EMBED:-false}
export ALLOW_UNSAFE_DATA_SCHEME=${ALLOW_UNSAFE_DATA_SCHEME:-false}
export MARKETPLACE_API_URL=https://marketplace.dify.ai
export MARKETPLACE_URL=https://marketplace.dify.ai
export PM2_INSTANCES=${PM2_INSTANCES:-2}

# Limits configuration
export LOOP_NODE_MAX_COUNT=${LOOP_NODE_MAX_COUNT:-100}
export MAX_TOOLS_NUM=${MAX_TOOLS_NUM:-10}
export MAX_PARALLEL_LIMIT=${MAX_PARALLEL_LIMIT:-10}
export MAX_ITERATIONS_NUM=${MAX_ITERATIONS_NUM:-99}
export MAX_TREE_DEPTH=${MAX_TREE_DEPTH:-50}

# Data sources
export ENABLE_WEBSITE_JINAREADER=${ENABLE_WEBSITE_JINAREADER:-true}
export ENABLE_WEBSITE_FIRECRAWL=${ENABLE_WEBSITE_FIRECRAWL:-true}
export ENABLE_WEBSITE_WATERCRAWL=${ENABLE_WEBSITE_WATERCRAWL:-true}

echo "🎯 Configurações do frontend:"
echo "API Prefix: $NEXT_PUBLIC_API_PREFIX"
echo "Public API Prefix: $NEXT_PUBLIC_PUBLIC_API_PREFIX"
echo "PM2 Instances: $PM2_INSTANCES"

# Start with PM2
echo "🚀 Iniciando servidor Next.js com PM2..."
exec pm2-runtime start server.js --instances $PM2_INSTANCES
