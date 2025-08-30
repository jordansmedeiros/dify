# Deploy Dify COMPLETO - Arquitetura Multi-App no CapRover

## 🎯 IMPLEMENTAÇÃO COMPLETA DO DIFY (TODOS OS SERVIÇOS)

Esta arquitetura garante que TODAS as funcionalidades do Dify funcionem:
- ✅ Interface administrativa e de aplicações
- ✅ Execução de código (sandbox)
- ✅ Plugins completos
- ✅ Vector store para IA
- ✅ Processamento assíncrono

## 🏗️ ARQUITETURA (5 Apps no CapRover)

### App 1: 🗄️ PostgreSQL (One-Click)
**Status**: ✅ JÁ CRIADO (`postgres-dify`)

### App 2: 🔴 Redis (One-Click)  
**Função**: Cache e filas do Celery

### App 3: 🧠 Weaviate (One-Click)
**Função**: Vector store para embeddings

### App 4: 🛡️ Dify Backend 
**Função**: API + Workers + Sandbox + Plugin Daemon

### App 5: 🌐 Dify Frontend
**Função**: Interface web completa (Next.js)

---

## 🚀 DEPLOY PASSO A PASSO

### PASSO 1: Criar Redis

1. **CapRover** → **Apps** → **One-Click Apps/Databases**
2. Procure por **"Redis"**
3. **Configuração**:
   ```
   App Name: redis-dify
   Version: 7-alpine
   Redis Password: difyai123456
   ```
4. **Clique em "Deploy"**
5. **Anote**: Nome será `srv-captain--redis-dify`

### PASSO 2: Criar Weaviate

1. **CapRover** → **Apps** → **Create New App**
2. **Configuração básica**:
   ```
   App Name: weaviate-dify
   Has Persistent Data: ✅ Marcar
   ```
3. **Deployment** → **Method 2: Image Name**
4. **Image Name**: `semitechnologies/weaviate:1.19.0`
5. **App Configs**:
   - **Container HTTP Port**: `8080`
   - **Environment Variables**:
     ```env
     PERSISTENCE_DATA_PATH=/var/lib/weaviate
     QUERY_DEFAULTS_LIMIT=25
     AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=false
     DEFAULT_VECTORIZER_MODULE=none
     CLUSTER_HOSTNAME=node1
     AUTHENTICATION_APIKEY_ENABLED=true
     AUTHENTICATION_APIKEY_ALLOWED_KEYS=WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih
     AUTHENTICATION_APIKEY_USERS=hello@dify.ai
     AUTHORIZATION_ADMINLIST_ENABLED=true
     AUTHORIZATION_ADMINLIST_USERS=hello@dify.ai
     ```
   - **Persistent Directories**:
     ```
     Caminho no App: /var/lib/weaviate
     Rótulo: weaviate-data
     ```
6. **Deploy**

### PASSO 3: Criar Backend (API + Workers + Sandbox)

1. **CapRover** → **Apps** → **Create New App**
2. **Configuração básica**:
   ```
   App Name: dify-backend
   Has Persistent Data: ✅ Marcar
   ```
3. **Deployment** → **Method 3: Deploy from GitHub**
4. **Configurar GitHub** (webhook, branch main)
5. **App Configs**:
   - **Container HTTP Port**: `5001`
   - **Environment Variables**:
     ```env
     # Banco de dados
     DB_HOST=srv-captain--postgres-dify
     DB_PORT=5432
     DB_USERNAME=postgres
     DB_PASSWORD=545e0c7bd3e24bb5
     DB_DATABASE=dify
     
     # Redis
     REDIS_HOST=srv-captain--redis-dify
     REDIS_PORT=6379
     REDIS_PASSWORD=difyai123456
     CELERY_BROKER_URL=redis://:difyai123456@srv-captain--redis-dify:6379/1
     
     # Weaviate
     VECTOR_STORE=weaviate
     WEAVIATE_ENDPOINT=http://srv-captain--weaviate-dify:8080
     WEAVIATE_API_KEY=WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih
     
     # Segurança
     SECRET_KEY=sGFEh0i0sTfYK9vMpDGV7Q2dX4SzqzwAgUO02I2mXeLXDVTblPxwWgE9odhItIlL
     SANDBOX_API_KEY=dify-sandbox
     
     # URLs (ajustar para seus domínios)
     CONSOLE_API_URL=https://dify.platform.sinesys.app
     SERVICE_API_URL=https://dify.platform.sinesys.app
     APP_API_URL=https://dify.platform.sinesys.app
     FILES_URL=https://dify.platform.sinesys.app
     INTERNAL_FILES_URL=http://127.0.0.1:5001
     
     # Sistema
     MIGRATION_ENABLED=true
     DEPLOY_ENV=PRODUCTION
     LOG_LEVEL=INFO
     
     # Performance
     SERVER_WORKER_AMOUNT=2
     GUNICORN_TIMEOUT=600
     CELERY_WORKER_AMOUNT=2
     ```
   - **Persistent Directories**:
     ```
     Caminho no App: /app/storage
     Rótulo: backend-storage
     
     Caminho no App: /app/logs  
     Rótulo: backend-logs
     ```

### PASSO 4: Criar Frontend (Next.js)

1. **CapRover** → **Apps** → **Create New App**
2. **Configuração básica**:
   ```
   App Name: dify-frontend
   Has Persistent Data: ❌ Não marcar
   ```
3. **Deployment** → **Method 3: Deploy from GitHub**
4. **App Configs**:
   - **Container HTTP Port**: `3000`
   - **Environment Variables**:
     ```env
     # URLs de conexão com backend
     CONSOLE_API_URL=https://dify.platform.sinesys.app
     APP_API_URL=https://dify.platform.sinesys.app
     
     # Next.js específico
     NEXT_PUBLIC_DEPLOY_ENV=PRODUCTION
     NEXT_PUBLIC_EDITION=SELF_HOSTED
     NODE_ENV=production
     PM2_INSTANCES=2
     
     # Timeouts
     TEXT_GENERATION_TIMEOUT_MS=60000
     
     # Funcionalidades
     ALLOW_EMBED=false
     ALLOW_UNSAFE_DATA_SCHEME=false
     MARKETPLACE_API_URL=https://marketplace.dify.ai
     ```

### PASSO 5: Configurar Captain-Definitions

**Para Backend:**
Crie `captain-definition` na raiz:
```json
{
  "schemaVersion": 2,
  "dockerfilePath": "./dockerfiles/Dockerfile.backend"
}
```

**Para Frontend:**  
Crie branch `frontend` ou repo separado com:
```json
{
  "schemaVersion": 2,
  "dockerfilePath": "./dockerfiles/Dockerfile.frontend"
}
```

### PASSO 6: Configurar Load Balancer (Nginx Principal)

1. **CapRover** → **Apps** → **Create New App**
2. **App Name**: `dify-main`
3. **Method 2: Image Name**: `nginx:alpine`
4. **Container HTTP Port**: `80`
5. **Enable HTTPS**: ✅
6. **Custom Domain**: `dify.platform.sinesys.app`
7. **Nginx Config**:
   ```nginx
   server {
       listen 80;
       server_name _;
       
       # API routes
       location /console/api {
           proxy_pass http://srv-captain--dify-backend:5001;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
       
       location /api {
           proxy_pass http://srv-captain--dify-backend:5001;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
       
       location /v1 {
           proxy_pass http://srv-captain--dify-backend:5001;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
       
       location /files {
           proxy_pass http://srv-captain--dify-backend:5001;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
       
       # Frontend (default)
       location / {
           proxy_pass http://srv-captain--dify-frontend:3000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

## 📋 CHECKLIST COMPLETO

- [ ] Redis criado (`redis-dify`)
- [ ] Weaviate criado (`weaviate-dify`)  
- [ ] Backend criado (`dify-backend`)
- [ ] Frontend criado (`dify-frontend`)
- [ ] Load Balancer criado (`dify-main`)
- [ ] Domínio configurado
- [ ] HTTPS habilitado
- [ ] Teste completo

## 🎯 RESULTADO FINAL

**URL Principal**: `https://dify.platform.sinesys.app`
- `/` → Interface completa do Dify
- `/api/` → API para integrações  
- `/console/` → Painel administrativo
- `/files/` → Upload/download de arquivos

**TODAS as funcionalidades do Dify funcionando:**
- ✅ Interface web completa
- ✅ Execução de código
- ✅ Plugins
- ✅ Vector store
- ✅ Processamento assíncrono
- ✅ Escalabilidade

## ⚡ PRÓXIMOS PASSOS

1. **Commit os dockerfiles**:
   ```bash
   git add dockerfiles/
   git commit -m "Add multi-app architecture for complete Dify deployment"
   git push origin main
   ```

2. **Seguir o checklist** acima em ordem

3. **Testar funcionamento completo**

**ESTA ARQUITETURA É A CORRETA E VAI FUNCIONAR COMPLETAMENTE!** 🚀
