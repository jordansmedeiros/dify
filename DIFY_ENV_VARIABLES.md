# Variáveis de Ambiente do Dify - Referência Completa

Este documento contém TODAS as variáveis de ambiente disponíveis no Dify, com seus valores padrão, descrições e opções possíveis.

## 📋 Índice

- [Variáveis Comuns](#variáveis-comuns)
- [Configuração do Servidor](#configuração-do-servidor)
- [Configuração de Container](#configuração-de-container)
- [Banco de Dados](#banco-de-dados)
- [Redis](#redis)
- [Celery](#celery)
- [CORS](#cors)
- [Armazenamento de Arquivos](#armazenamento-de-arquivos)
- [Vector Database](#vector-database)
- [Configuração de Conhecimento](#configuração-de-conhecimento)
- [Configuração de Modelos](#configuração-de-modelos)
- [Multi-modal](#multi-modal)
- [Sentry (Monitoramento)](#sentry-monitoramento)
- [Integração Notion](#integração-notion)
- [Configuração de Email](#configuração-de-email)
- [Outras Configurações](#outras-configurações)
- [Workflow](#workflow)
- [Plugin Daemon](#plugin-daemon)
- [Observabilidade](#observabilidade)
- [Nginx](#nginx)
- [Certbot](#certbot)
- [SSRF Proxy](#ssrf-proxy)

---

## Variáveis Comuns

```env
# URL da API do console (backend para interface administrativa)
# Se vazio, usa o mesmo domínio
# Exemplo: https://api.console.dify.ai
CONSOLE_API_URL=

# URL do console web (frontend administrativo)
# Se vazio, usa o mesmo domínio
# Exemplo: https://console.dify.ai
CONSOLE_WEB_URL=

# URL da API de serviço (API pública)
# Se vazio, usa o mesmo domínio
# Exemplo: https://api.dify.ai
SERVICE_API_URL=

# URL da API do WebApp (backend para aplicações criadas)
# Se vazio, usa o mesmo domínio
# Exemplo: https://api.app.dify.ai
APP_API_URL=

# URL do WebApp (frontend das aplicações criadas)
# Se vazio, usa o mesmo domínio
# Exemplo: https://app.dify.ai
APP_WEB_URL=

# URL para preview/download de arquivos
# URLs são assinadas e têm tempo de expiração
# OBRIGATÓRIO para processamento de arquivos com plugins
# Exemplos:
#   - https://example.com
#   - http://example.com
#   - https://upload.example.com (recomendado: domínio dedicado)
#   - http://<seu-ip>:5001
#   - http://api:5001 (garanta que porta 5001 seja acessível externamente)
FILES_URL=

# URL interna para comunicação do plugin daemon dentro da rede Docker
# Exemplo: http://api:5001
INTERNAL_FILES_URL=

# Configuração de codificação UTF-8
LANG=en_US.UTF-8          # Padrão: en_US.UTF-8
LC_ALL=en_US.UTF-8         # Padrão: en_US.UTF-8
PYTHONIOENCODING=utf-8     # Padrão: utf-8
```

## Configuração do Servidor

```env
# Nível de log da aplicação
# Valores: DEBUG, INFO, WARNING, ERROR, CRITICAL
LOG_LEVEL=INFO             # Padrão: INFO

# Caminho do arquivo de log
LOG_FILE=/app/logs/server.log  # Padrão: /app/logs/server.log

# Tamanho máximo do arquivo de log em MB
LOG_FILE_MAX_SIZE=20       # Padrão: 20

# Número máximo de backups do arquivo de log
LOG_FILE_BACKUP_COUNT=5    # Padrão: 5

# Formato de data/hora nos logs
LOG_DATEFORMAT=%Y-%m-%d %H:%M:%S  # Padrão: %Y-%m-%d %H:%M:%S

# Timezone dos logs
LOG_TZ=UTC                 # Padrão: UTC

# Modo debug (desativa monkey patch)
# Recomendado true para desenvolvimento local
DEBUG=false                # Padrão: false

# Modo debug do Flask (mostra trace de erros)
FLASK_DEBUG=false          # Padrão: false

# Habilita log de requisições HTTP (nível DEBUG)
ENABLE_REQUEST_LOGGING=False  # Padrão: False

# Chave secreta para assinatura de cookies e criptografia
# IMPORTANTE: Gere com 'openssl rand -base64 42'
SECRET_KEY=sk-9f73s3ljTXVcMT3Blb3ljTqtsKiGHXVcMT3BlbkFJLK7U

# Senha para inicialização do usuário admin
# Se vazio, não solicita senha na criação inicial
# Máximo 30 caracteres
INIT_PASSWORD=

# Ambiente de deploy
# Valores: PRODUCTION, TESTING
# TESTING mostra label colorido indicando ambiente de teste
DEPLOY_ENV=PRODUCTION      # Padrão: PRODUCTION

# URL para verificação de versão
# Se vazio, não verifica atualizações
CHECK_UPDATE_URL=https://updates.dify.ai  # Padrão: https://updates.dify.ai

# Base URL da API OpenAI (ou compatível)
OPENAI_API_BASE=https://api.openai.com/v1  # Padrão: https://api.openai.com/v1

# Executa migrações do banco antes de iniciar
MIGRATION_ENABLED=true     # Padrão: true

# Tempo de acesso a arquivos em segundos
FILES_ACCESS_TIMEOUT=300   # Padrão: 300

# Tempo de expiração do token de acesso em minutos
ACCESS_TOKEN_EXPIRE_MINUTES=60  # Padrão: 60

# Tempo de expiração do refresh token em dias
REFRESH_TOKEN_EXPIRE_DAYS=30    # Padrão: 30

# Máximo de requisições ativas por aplicação (0 = ilimitado)
APP_MAX_ACTIVE_REQUESTS=0  # Padrão: 0

# Tempo máximo de execução da aplicação em segundos
APP_MAX_EXECUTION_TIME=1200  # Padrão: 1200
```

## Configuração de Container

```env
# Endereço de bind da API
DIFY_BIND_ADDRESS=0.0.0.0  # Padrão: 0.0.0.0

# Porta da API
DIFY_PORT=5001             # Padrão: 5001

# Número de workers da API
# Fórmula: (CPU cores * 2) + 1 para sync, 1 para gevent
SERVER_WORKER_AMOUNT=1     # Padrão: 1

# Classe de worker
# Valores: gevent (padrão), sync, solo (Windows)
SERVER_WORKER_CLASS=gevent  # Padrão: gevent

# Número de conexões por worker
SERVER_WORKER_CONNECTIONS=10  # Padrão: 10

# Classe de worker do Celery
# Valores: gevent (padrão), sync, solo (Windows)
CELERY_WORKER_CLASS=

# Timeout de requisições em segundos
GUNICORN_TIMEOUT=360       # Padrão: 360

# Número de workers do Celery
CELERY_WORKER_AMOUNT=

# Habilita auto-scaling de workers Celery
CELERY_AUTO_SCALE=false    # Padrão: false

# Máximo de workers em auto-scaling
CELERY_MAX_WORKERS=

# Mínimo de workers em auto-scaling
CELERY_MIN_WORKERS=

# Configurações de timeout para ferramentas de API
API_TOOL_DEFAULT_CONNECT_TIMEOUT=10  # Padrão: 10
API_TOOL_DEFAULT_READ_TIMEOUT=60     # Padrão: 60
```

## Banco de Dados

```env
# PostgreSQL - Configurações principais
DB_USERNAME=postgres       # Padrão: postgres
DB_PASSWORD=difyai123456   # Padrão: difyai123456
DB_HOST=db                 # Padrão: db
DB_PORT=5432              # Padrão: 5432
DB_DATABASE=dify          # Padrão: dify

# Pool de conexões
SQLALCHEMY_POOL_SIZE=30    # Padrão: 30
SQLALCHEMY_MAX_OVERFLOW=10 # Padrão: 10
SQLALCHEMY_POOL_RECYCLE=3600  # Padrão: 3600 segundos

# Debug e otimização
SQLALCHEMY_ECHO=false      # Padrão: false (imprime SQL)
SQLALCHEMY_POOL_PRE_PING=false  # Padrão: false (testa conexões)
SQLALCHEMY_POOL_USE_LIFO=false  # Padrão: false (FIFO por padrão)

# Configurações PostgreSQL
POSTGRES_MAX_CONNECTIONS=100     # Padrão: 100
POSTGRES_SHARED_BUFFERS=128MB    # Padrão: 128MB (recomendado: 25% RAM)
POSTGRES_WORK_MEM=4MB            # Padrão: 4MB
POSTGRES_MAINTENANCE_WORK_MEM=64MB  # Padrão: 64MB
POSTGRES_EFFECTIVE_CACHE_SIZE=4096MB  # Padrão: 4096MB

# Variáveis específicas do container PostgreSQL
POSTGRES_USER=${DB_USERNAME}
POSTGRES_PASSWORD=${DB_PASSWORD}
POSTGRES_DB=${DB_DATABASE}
PGDATA=/var/lib/postgresql/data/pgdata
```

## Redis

```env
# Configurações básicas
REDIS_HOST=redis          # Padrão: redis
REDIS_PORT=6379          # Padrão: 6379
REDIS_USERNAME=          # Padrão: vazio
REDIS_PASSWORD=difyai123456  # Padrão: difyai123456
REDIS_DB=0               # Padrão: 0

# SSL
REDIS_USE_SSL=false      # Padrão: false
REDIS_SSL_CERT_REQS=CERT_NONE  # Valores: CERT_NONE, CERT_OPTIONAL, CERT_REQUIRED
REDIS_SSL_CA_CERTS=      # Caminho para CA certificate
REDIS_SSL_CERTFILE=      # Caminho para client certificate
REDIS_SSL_KEYFILE=       # Caminho para client key

# Redis Sentinel (alta disponibilidade)
REDIS_USE_SENTINEL=false  # Padrão: false
REDIS_SENTINELS=         # Formato: ip1:porta1,ip2:porta2
REDIS_SENTINEL_SERVICE_NAME=
REDIS_SENTINEL_USERNAME=
REDIS_SENTINEL_PASSWORD=
REDIS_SENTINEL_SOCKET_TIMEOUT=0.1  # Padrão: 0.1

# Redis Cluster
REDIS_USE_CLUSTERS=false  # Padrão: false
REDIS_CLUSTERS=          # Formato: ip1:porta1,ip2:porta2
REDIS_CLUSTERS_PASSWORD=
```

## Celery

```env
# URL do broker
# Formato: redis://<username>:<password>@<host>:<port>/<database>
CELERY_BROKER_URL=redis://:difyai123456@redis:6379/1

# Backend
CELERY_BACKEND=redis      # Padrão: redis

# SSL do broker
BROKER_USE_SSL=false      # Padrão: false

# Sentinel para Celery
CELERY_USE_SENTINEL=false  # Padrão: false
CELERY_SENTINEL_MASTER_NAME=
CELERY_SENTINEL_PASSWORD=
CELERY_SENTINEL_SOCKET_TIMEOUT=0.1  # Padrão: 0.1

# Filas do Celery
CELERY_QUEUES=dataset,generation,mail,ops_trace,app_deletion
```

## CORS

```env
# Origens permitidas para Web API
# Valores: * (todas) ou URLs específicas separadas por vírgula
WEB_API_CORS_ALLOW_ORIGINS=*  # Padrão: *

# Origens permitidas para Console API
CONSOLE_CORS_ALLOW_ORIGINS=*  # Padrão: *
```

## Armazenamento de Arquivos

```env
# Tipo de armazenamento
# Valores: opendal (padrão), s3, azure-blob, google-storage, 
#         aliyun-oss, tencent-cos, oci, huawei-obs, volcengine-tos,
#         baidu-obs, supabase, clickzetta-volume
STORAGE_TYPE=opendal      # Padrão: opendal

# OpenDAL (armazenamento local)
OPENDAL_SCHEME=fs         # Padrão: fs (filesystem)
OPENDAL_FS_ROOT=storage   # Padrão: storage

# S3 / AWS
S3_ENDPOINT=
S3_REGION=us-east-1       # Padrão: us-east-1
S3_BUCKET_NAME=difyai     # Padrão: difyai
S3_ACCESS_KEY=
S3_SECRET_KEY=
S3_USE_AWS_MANAGED_IAM=false  # Padrão: false

# Azure Blob Storage
AZURE_BLOB_ACCOUNT_NAME=difyai
AZURE_BLOB_ACCOUNT_KEY=difyai
AZURE_BLOB_CONTAINER_NAME=difyai-container
AZURE_BLOB_ACCOUNT_URL=https://<your_account_name>.blob.core.windows.net

# Google Cloud Storage
GOOGLE_STORAGE_BUCKET_NAME=your-bucket-name
GOOGLE_STORAGE_SERVICE_ACCOUNT_JSON_BASE64=

# Alibaba Cloud OSS
ALIYUN_OSS_BUCKET_NAME=your-bucket-name
ALIYUN_OSS_ACCESS_KEY=your-access-key
ALIYUN_OSS_SECRET_KEY=your-secret-key
ALIYUN_OSS_ENDPOINT=https://oss-ap-southeast-1-internal.aliyuncs.com
ALIYUN_OSS_REGION=ap-southeast-1
ALIYUN_OSS_AUTH_VERSION=v4
ALIYUN_OSS_PATH=your-path  # Não começar com /

# Tencent COS
TENCENT_COS_BUCKET_NAME=your-bucket-name
TENCENT_COS_SECRET_KEY=your-secret-key
TENCENT_COS_SECRET_ID=your-secret-id
TENCENT_COS_REGION=your-region
TENCENT_COS_SCHEME=your-scheme

# Oracle Cloud Infrastructure
OCI_ENDPOINT=https://your-namespace.compat.objectstorage.us-ashburn-1.oraclecloud.com
OCI_BUCKET_NAME=your-bucket-name
OCI_ACCESS_KEY=your-access-key
OCI_SECRET_KEY=your-secret-key
OCI_REGION=us-ashburn-1

# Huawei OBS
HUAWEI_OBS_BUCKET_NAME=your-bucket-name
HUAWEI_OBS_SECRET_KEY=your-secret-key
HUAWEI_OBS_ACCESS_KEY=your-access-key
HUAWEI_OBS_SERVER=your-server-url

# Volcengine TOS
VOLCENGINE_TOS_BUCKET_NAME=your-bucket-name
VOLCENGINE_TOS_SECRET_KEY=your-secret-key
VOLCENGINE_TOS_ACCESS_KEY=your-access-key
VOLCENGINE_TOS_ENDPOINT=your-server-url
VOLCENGINE_TOS_REGION=your-region

# Baidu OBS
BAIDU_OBS_BUCKET_NAME=your-bucket-name
BAIDU_OBS_SECRET_KEY=your-secret-key
BAIDU_OBS_ACCESS_KEY=your-access-key
BAIDU_OBS_ENDPOINT=your-server-url

# Supabase Storage
SUPABASE_BUCKET_NAME=your-bucket-name
SUPABASE_API_KEY=your-access-key
SUPABASE_URL=your-server-url

# ClickZetta Volume
CLICKZETTA_VOLUME_TYPE=user  # Valores: user, table, external
CLICKZETTA_VOLUME_NAME=
CLICKZETTA_VOLUME_TABLE_PREFIX=dataset_
CLICKZETTA_VOLUME_DIFY_PREFIX=dify_km
```

## Vector Database

```env
# Tipo de vector store
# Valores: weaviate, qdrant, milvus, myscale, relyt, pgvector, 
#         pgvecto-rs, chroma, opensearch, oracle, tencent, 
#         elasticsearch, elasticsearch-ja, analyticdb, couchbase,
#         vikingdb, oceanbase, opengauss, tablestore, vastbase,
#         tidb, tidb_on_qdrant, baidu, lindorm, huawei_cloud,
#         upstash, matrixone, clickzetta
VECTOR_STORE=weaviate     # Padrão: weaviate

# Prefixo para nomes de coleções
VECTOR_INDEX_NAME_PREFIX=Vector_index  # Padrão: Vector_index

# Weaviate
WEAVIATE_ENDPOINT=http://weaviate:8080
WEAVIATE_API_KEY=WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih
WEAVIATE_PERSISTENCE_DATA_PATH=/var/lib/weaviate
WEAVIATE_QUERY_DEFAULTS_LIMIT=25
WEAVIATE_AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true
WEAVIATE_DEFAULT_VECTORIZER_MODULE=none
WEAVIATE_CLUSTER_HOSTNAME=node1
WEAVIATE_AUTHENTICATION_APIKEY_ENABLED=true
WEAVIATE_AUTHENTICATION_APIKEY_ALLOWED_KEYS=WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih
WEAVIATE_AUTHENTICATION_APIKEY_USERS=hello@dify.ai
WEAVIATE_AUTHORIZATION_ADMINLIST_ENABLED=true
WEAVIATE_AUTHORIZATION_ADMINLIST_USERS=hello@dify.ai

# Qdrant
QDRANT_URL=http://qdrant:6333
QDRANT_API_KEY=difyai123456
QDRANT_CLIENT_TIMEOUT=20
QDRANT_GRPC_ENABLED=false
QDRANT_GRPC_PORT=6334
QDRANT_REPLICATION_FACTOR=1

# Milvus
MILVUS_URI=http://host.docker.internal:19530
MILVUS_DATABASE=
MILVUS_TOKEN=
MILVUS_USER=
MILVUS_PASSWORD=
MILVUS_ENABLE_HYBRID_SEARCH=False
MILVUS_ANALYZER_PARAMS=
MILVUS_AUTHORIZATION_ENABLED=true
ETCD_ENDPOINTS=etcd:2379
MINIO_ADDRESS=minio:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin

# PGVector
PGVECTOR_HOST=pgvector
PGVECTOR_PORT=5432
PGVECTOR_USER=postgres
PGVECTOR_PASSWORD=difyai123456
PGVECTOR_DATABASE=dify
PGVECTOR_MIN_CONNECTION=1
PGVECTOR_MAX_CONNECTION=5
PGVECTOR_PG_BIGM=false    # Full text search
PGVECTOR_PG_BIGM_VERSION=1.2-20240606
PGVECTOR_PGUSER=postgres
PGVECTOR_POSTGRES_PASSWORD=difyai123456
PGVECTOR_POSTGRES_DB=dify
PGVECTOR_PGDATA=/var/lib/postgresql/data/pgdata

# Chroma
CHROMA_HOST=127.0.0.1
CHROMA_PORT=8000
CHROMA_TENANT=default_tenant
CHROMA_DATABASE=default_database
CHROMA_AUTH_PROVIDER=chromadb.auth.token_authn.TokenAuthClientProvider
CHROMA_AUTH_CREDENTIALS=
CHROMA_SERVER_AUTHN_CREDENTIALS=difyai123456
CHROMA_SERVER_AUTHN_PROVIDER=chromadb.auth.token_authn.TokenAuthenticationServerProvider
CHROMA_IS_PERSISTENT=TRUE

# ElasticSearch
ELASTICSEARCH_HOST=0.0.0.0
ELASTICSEARCH_PORT=9200
ELASTICSEARCH_USERNAME=elastic
ELASTICSEARCH_PASSWORD=elastic
KIBANA_PORT=5601
ELASTICSEARCH_USE_CLOUD=false
ELASTICSEARCH_CLOUD_URL=YOUR-ELASTICSEARCH_CLOUD_URL
ELASTICSEARCH_API_KEY=YOUR-ELASTICSEARCH_API_KEY
ELASTICSEARCH_VERIFY_CERTS=False
ELASTICSEARCH_CA_CERTS=
ELASTICSEARCH_REQUEST_TIMEOUT=100000
ELASTICSEARCH_RETRY_ON_TIMEOUT=True
ELASTICSEARCH_MAX_RETRIES=10

# OpenSearch
OPENSEARCH_HOST=opensearch
OPENSEARCH_PORT=9200
OPENSEARCH_SECURE=true
OPENSEARCH_VERIFY_CERTS=true
OPENSEARCH_AUTH_METHOD=basic  # Valores: basic, aws
OPENSEARCH_USER=admin
OPENSEARCH_PASSWORD=admin
OPENSEARCH_AWS_REGION=ap-southeast-1
OPENSEARCH_AWS_SERVICE=aoss
OPENSEARCH_DISCOVERY_TYPE=single-node
OPENSEARCH_BOOTSTRAP_MEMORY_LOCK=true
OPENSEARCH_JAVA_OPTS_MIN=512m
OPENSEARCH_JAVA_OPTS_MAX=1024m
OPENSEARCH_INITIAL_ADMIN_PASSWORD=Qazwsxedc!@#123
```

## Configuração de Conhecimento

```env
# Fontes de dados
ENABLE_WEBSITE_JINAREADER=true   # Padrão: true
ENABLE_WEBSITE_FIRECRAWL=true    # Padrão: true
ENABLE_WEBSITE_WATERCRAWL=true   # Padrão: true

# Limite de tamanho de arquivo em MB
UPLOAD_FILE_SIZE_LIMIT=15  # Padrão: 15

# Número máximo de arquivos por upload
UPLOAD_FILE_BATCH_LIMIT=5  # Padrão: 5

# Tipo de ETL
# Valores: dify (proprietário), Unstructured (unstructured.io)
ETL_TYPE=dify             # Padrão: dify

# Configurações Unstructured (quando ETL_TYPE=Unstructured)
UNSTRUCTURED_API_URL=
UNSTRUCTURED_API_KEY=
SCARF_NO_ANALYTICS=true

# Tamanho máximo de tokens para segmentação
INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH=4000  # Padrão: 4000
```

## Configuração de Modelos

```env
# Máximo de tokens para geração de prompt
PROMPT_GENERATION_MAX_TOKENS=512  # Padrão: 512

# Máximo de tokens para geração de código
CODE_GENERATION_MAX_TOKENS=1024   # Padrão: 1024

# Habilita contagem de tokens baseada em plugin
PLUGIN_BASED_TOKEN_COUNTING_ENABLED=false  # Padrão: false
```

## Multi-modal

```env
# Formato de envio de mídia
# Valores: base64 (padrão), url
MULTIMODAL_SEND_FORMAT=base64  # Padrão: base64

# Limites de upload em MB
UPLOAD_IMAGE_FILE_SIZE_LIMIT=10   # Padrão: 10
UPLOAD_VIDEO_FILE_SIZE_LIMIT=100  # Padrão: 100
UPLOAD_AUDIO_FILE_SIZE_LIMIT=50   # Padrão: 50
```

## Sentry (Monitoramento)

```env
# DSN geral do Sentry
SENTRY_DSN=

# DSN específico da API
API_SENTRY_DSN=
API_SENTRY_TRACES_SAMPLE_RATE=1.0    # Padrão: 1.0 (100%)
API_SENTRY_PROFILES_SAMPLE_RATE=1.0  # Padrão: 1.0 (100%)

# DSN específico do Web
WEB_SENTRY_DSN=

# DSN específico do Plugin Daemon
PLUGIN_SENTRY_ENABLED=false
PLUGIN_SENTRY_DSN=
```

## Integração Notion

```env
# Tipo de integração
# Valores: public (OAuth), internal (token)
NOTION_INTEGRATION_TYPE=public  # Padrão: public

# Para integração pública (OAuth)
NOTION_CLIENT_SECRET=
NOTION_CLIENT_ID=

# Para integração interna
NOTION_INTERNAL_SECRET=
```

## Configuração de Email

```env
# Tipo de provedor
# Valores: resend, smtp, sendgrid
MAIL_TYPE=resend          # Padrão: resend

# Endereço de envio padrão
MAIL_DEFAULT_SEND_FROM=

# Resend
RESEND_API_URL=https://api.resend.com
RESEND_API_KEY=your-resend-api-key

# SMTP
SMTP_SERVER=
SMTP_PORT=465             # Padrão: 465
SMTP_USERNAME=
SMTP_PASSWORD=
SMTP_USE_TLS=true         # Padrão: true
SMTP_OPPORTUNISTIC_TLS=false  # Padrão: false

# SendGrid
SENDGRID_API_KEY=
```

## Outras Configurações

```env
# Tempo de validade de convites em horas
INVITE_EXPIRY_HOURS=72    # Padrão: 72

# Tempo de validade de tokens em minutos
RESET_PASSWORD_TOKEN_EXPIRY_MINUTES=5   # Padrão: 5
CHANGE_EMAIL_TOKEN_EXPIRY_MINUTES=5     # Padrão: 5
OWNER_TRANSFER_TOKEN_EXPIRY_MINUTES=5   # Padrão: 5

# Sandbox para execução de código
CODE_EXECUTION_ENDPOINT=http://sandbox:8194
CODE_EXECUTION_API_KEY=dify-sandbox

# Limites de código
CODE_MAX_NUMBER=9223372036854775807     # Máximo int64
CODE_MIN_NUMBER=-9223372036854775808    # Mínimo int64
CODE_MAX_DEPTH=5          # Profundidade máxima de objetos
CODE_MAX_PRECISION=20     # Precisão decimal máxima
CODE_MAX_STRING_LENGTH=80000
CODE_MAX_STRING_ARRAY_LENGTH=30
CODE_MAX_OBJECT_ARRAY_LENGTH=30
CODE_MAX_NUMBER_ARRAY_LENGTH=1000

# Timeouts de execução de código
CODE_EXECUTION_CONNECT_TIMEOUT=10  # Padrão: 10
CODE_EXECUTION_READ_TIMEOUT=60     # Padrão: 60
CODE_EXECUTION_WRITE_TIMEOUT=10    # Padrão: 10

# Tamanho máximo de template
TEMPLATE_TRANSFORM_MAX_LENGTH=80000  # Padrão: 80000
```

## Workflow

```env
# Limites de execução
WORKFLOW_MAX_EXECUTION_STEPS=500   # Padrão: 500
WORKFLOW_MAX_EXECUTION_TIME=1200   # Padrão: 1200 segundos
WORKFLOW_CALL_MAX_DEPTH=5          # Padrão: 5
MAX_VARIABLE_SIZE=204800           # Padrão: 204800 bytes
WORKFLOW_PARALLEL_DEPTH_LIMIT=3    # Padrão: 3
WORKFLOW_FILE_UPLOAD_LIMIT=10      # Padrão: 10

# Armazenamento de execução
# Valores: rdbms (padrão), hybrid
WORKFLOW_NODE_EXECUTION_STORAGE=rdbms  # Padrão: rdbms

# Repositórios (implementações internas)
CORE_WORKFLOW_EXECUTION_REPOSITORY=core.repositories.sqlalchemy_workflow_execution_repository.SQLAlchemyWorkflowExecutionRepository
CORE_WORKFLOW_NODE_EXECUTION_REPOSITORY=core.repositories.sqlalchemy_workflow_node_execution_repository.SQLAlchemyWorkflowNodeExecutionRepository
API_WORKFLOW_RUN_REPOSITORY=repositories.sqlalchemy_api_workflow_run_repository.DifyAPISQLAlchemyWorkflowRunRepository
API_WORKFLOW_NODE_EXECUTION_REPOSITORY=repositories.sqlalchemy_api_workflow_node_execution_repository.DifyAPISQLAlchemyWorkflowNodeExecutionRepository

# Limpeza de logs
WORKFLOW_LOG_CLEANUP_ENABLED=false  # Padrão: false
WORKFLOW_LOG_RETENTION_DAYS=30      # Padrão: 30 dias
WORKFLOW_LOG_CLEANUP_BATCH_SIZE=100 # Padrão: 100

# Nó de requisição HTTP
HTTP_REQUEST_NODE_MAX_BINARY_SIZE=10485760  # 10MB
HTTP_REQUEST_NODE_MAX_TEXT_SIZE=1048576     # 1MB
HTTP_REQUEST_NODE_SSL_VERIFY=True   # Padrão: True

# Headers X-Forwarded
RESPECT_XFORWARD_HEADERS_ENABLED=false  # Padrão: false

# SSRF Proxy
SSRF_PROXY_HTTP_URL=http://ssrf_proxy:3128
SSRF_PROXY_HTTPS_URL=http://ssrf_proxy:3128

# Limites de nós
LOOP_NODE_MAX_COUNT=100   # Máximo de iterações em loop
MAX_TOOLS_NUM=10          # Máximo de ferramentas no agente
MAX_PARALLEL_LIMIT=10     # Máximo de branches paralelos
MAX_ITERATIONS_NUM=99     # Máximo de iterações do agente

# Timeout de geração de texto
TEXT_GENERATION_TIMEOUT_MS=60000  # Padrão: 60000ms

# Permite URLs unsafe com esquema "data:"
ALLOW_UNSAFE_DATA_SCHEME=false  # Padrão: false

# Profundidade máxima da árvore do workflow
MAX_TREE_DEPTH=50         # Padrão: 50
```

## Plugin Daemon

```env
# Banco de dados dos plugins
DB_PLUGIN_DATABASE=dify_plugin

# Portas
EXPOSE_PLUGIN_DAEMON_PORT=5002
PLUGIN_DAEMON_PORT=5002
EXPOSE_PLUGIN_DEBUGGING_HOST=localhost
EXPOSE_PLUGIN_DEBUGGING_PORT=5003
PLUGIN_DEBUGGING_HOST=0.0.0.0
PLUGIN_DEBUGGING_PORT=5003

# Chaves de segurança
PLUGIN_DAEMON_KEY=lYkiYYT6owG+71oLerGzA7GXCgOT++6ovaezWAjpCjf+Sjc3ZtU+qUEi
PLUGIN_DIFY_INNER_API_KEY=QaHbTe77CtuXmsfyhR7+vRjI/+XbV1AaFy691iy+kGDv2Jvy0/eAh8Y1

# URLs
PLUGIN_DAEMON_URL=http://plugin_daemon:5002
PLUGIN_DIFY_INNER_API_URL=http://api:5001
ENDPOINT_URL_TEMPLATE=http://localhost/e/{hook_id}

# Marketplace
MARKETPLACE_ENABLED=true   # Padrão: true
MARKETPLACE_API_URL=https://marketplace.dify.ai
MARKETPLACE_URL=https://marketplace.dify.ai
FORCE_VERIFYING_SIGNATURE=true  # Padrão: true

# Limites e timeouts
PLUGIN_MAX_PACKAGE_SIZE=52428800  # 50MB
PLUGIN_STDIO_BUFFER_SIZE=1024
PLUGIN_STDIO_MAX_BUFFER_SIZE=5242880  # 5MB
PLUGIN_PYTHON_ENV_INIT_TIMEOUT=120
PLUGIN_MAX_EXECUTION_TIMEOUT=600

# Mirror PyPI (China/outros)
PIP_MIRROR_URL=           # Ex: https://pypi.tuna.tsinghua.edu.cn/simple

# Profiling
PLUGIN_PPROF_ENABLED=false  # Padrão: false

# Armazenamento de plugins
PLUGIN_STORAGE_TYPE=local  # Valores: local, aws_s3, tencent_cos, azure_blob, aliyun_oss, volcengine_tos
PLUGIN_STORAGE_LOCAL_ROOT=/app/storage
PLUGIN_WORKING_PATH=/app/storage/cwd
PLUGIN_INSTALLED_PATH=plugin
PLUGIN_PACKAGE_CACHE_PATH=plugin_packages
PLUGIN_MEDIA_CACHE_PATH=assets

# S3 para plugins
PLUGIN_STORAGE_OSS_BUCKET=
PLUGIN_S3_USE_AWS=false
PLUGIN_S3_USE_AWS_MANAGED_IAM=false
PLUGIN_S3_ENDPOINT=
PLUGIN_S3_USE_PATH_STYLE=false
PLUGIN_AWS_ACCESS_KEY=
PLUGIN_AWS_SECRET_KEY=
PLUGIN_AWS_REGION=

# Azure Blob para plugins
PLUGIN_AZURE_BLOB_STORAGE_CONTAINER_NAME=
PLUGIN_AZURE_BLOB_STORAGE_CONNECTION_STRING=

# Tencent COS para plugins
PLUGIN_TENCENT_COS_SECRET_KEY=
PLUGIN_TENCENT_COS_SECRET_ID=
PLUGIN_TENCENT_COS_REGION=

# Aliyun OSS para plugins
PLUGIN_ALIYUN_OSS_REGION=
PLUGIN_ALIYUN_OSS_ENDPOINT=
PLUGIN_ALIYUN_OSS_ACCESS_KEY_ID=
PLUGIN_ALIYUN_OSS_ACCESS_KEY_SECRET=
PLUGIN_ALIYUN_OSS_AUTH_VERSION=v4
PLUGIN_ALIYUN_OSS_PATH=

# Volcengine TOS para plugins
PLUGIN_VOLCENGINE_TOS_ENDPOINT=
PLUGIN_VOLCENGINE_TOS_ACCESS_KEY=
PLUGIN_VOLCENGINE_TOS_SECRET_KEY=
PLUGIN_VOLCENGINE_TOS_REGION=
```

## Observabilidade

```env
# OpenTelemetry
ENABLE_OTEL=false         # Padrão: false

# Endpoints
OTLP_TRACE_ENDPOINT=
OTLP_METRIC_ENDPOINT=
OTLP_BASE_ENDPOINT=http://localhost:4318  # Padrão: http://localhost:4318
OTLP_API_KEY=

# Protocolo e exportador
OTEL_EXPORTER_OTLP_PROTOCOL=
OTEL_EXPORTER_TYPE=otlp   # Padrão: otlp

# Sampling e batching
OTEL_SAMPLING_RATE=0.1    # Padrão: 0.1 (10%)
OTEL_BATCH_EXPORT_SCHEDULE_DELAY=5000    # Padrão: 5000ms
OTEL_MAX_QUEUE_SIZE=2048  # Padrão: 2048
OTEL_MAX_EXPORT_BATCH_SIZE=512  # Padrão: 512

# Métricas
OTEL_METRIC_EXPORT_INTERVAL=60000  # Padrão: 60000ms
OTEL_METRIC_EXPORT_TIMEOUT=30000   # Padrão: 30000ms

# Timeouts gerais
OTEL_BATCH_EXPORT_TIMEOUT=10000    # Padrão: 10000ms
```

## Segurança e Políticas

```env
# Prevenir Clickjacking
ALLOW_EMBED=false         # Padrão: false

# CSP (Content Security Policy)
CSP_WHITELIST=            # URLs separadas por vírgula

# Posicionamento de ferramentas e provedores
POSITION_TOOL_PINS=       # Ex: bing,google
POSITION_TOOL_INCLUDES=
POSITION_TOOL_EXCLUDES=
POSITION_PROVIDER_PINS=   # Ex: openai,openllm
POSITION_PROVIDER_INCLUDES=
POSITION_PROVIDER_EXCLUDES=

# Limites
TOP_K_MAX_VALUE=10        # Padrão: 10
MAX_SUBMIT_COUNT=100      # Padrão: 100
```

## Nginx

```env
# Configurações do servidor
NGINX_SERVER_NAME=_       # Padrão: _ (qualquer)
NGINX_HTTPS_ENABLED=false # Padrão: false
NGINX_PORT=80            # Padrão: 80
NGINX_SSL_PORT=443       # Padrão: 443

# Certificados SSL (quando HTTPS_ENABLED=true)
NGINX_SSL_CERT_FILENAME=dify.crt       # Padrão: dify.crt
NGINX_SSL_CERT_KEY_FILENAME=dify.key   # Padrão: dify.key
NGINX_SSL_PROTOCOLS=TLSv1.1 TLSv1.2 TLSv1.3  # Padrão: TLSv1.1 TLSv1.2 TLSv1.3

# Performance
NGINX_WORKER_PROCESSES=auto  # Padrão: auto
NGINX_CLIENT_MAX_BODY_SIZE=100M  # Padrão: 100M
NGINX_KEEPALIVE_TIMEOUT=65       # Padrão: 65

# Timeouts de proxy
NGINX_PROXY_READ_TIMEOUT=3600s   # Padrão: 3600s
NGINX_PROXY_SEND_TIMEOUT=3600s   # Padrão: 3600s

# Certbot challenge
NGINX_ENABLE_CERTBOT_CHALLENGE=false  # Padrão: false

# Portas expostas no Docker
EXPOSE_NGINX_PORT=80      # Padrão: 80
EXPOSE_NGINX_SSL_PORT=443  # Padrão: 443
```

## Certbot (Let's Encrypt)

```env
# Email para certificados Let's Encrypt
CERTBOT_EMAIL=your_email@example.com

# Domínio
CERTBOT_DOMAIN=your_domain.com

# Opções adicionais do certbot
# Ex: --force-renewal --dry-run --test-cert --debug
CERTBOT_OPTIONS=
```

## SSRF Proxy

```env
# Portas e configurações
SSRF_HTTP_PORT=3128       # Padrão: 3128
SSRF_COREDUMP_DIR=/var/spool/squid
SSRF_REVERSE_PROXY_PORT=8194
SSRF_SANDBOX_HOST=sandbox

# Timeouts
SSRF_DEFAULT_TIME_OUT=5           # Padrão: 5
SSRF_DEFAULT_CONNECT_TIME_OUT=5   # Padrão: 5
SSRF_DEFAULT_READ_TIME_OUT=5      # Padrão: 5
SSRF_DEFAULT_WRITE_TIME_OUT=5     # Padrão: 5
```

## Sandbox

```env
# Configurações básicas
SANDBOX_API_KEY=dify-sandbox      # Padrão: dify-sandbox
SANDBOX_GIN_MODE=release          # Valores: debug, release
SANDBOX_WORKER_TIMEOUT=15         # Padrão: 15
SANDBOX_ENABLE_NETWORK=true       # Padrão: true
SANDBOX_PORT=8194                 # Padrão: 8194

# Proxy para sandbox
SANDBOX_HTTP_PROXY=http://ssrf_proxy:3128
SANDBOX_HTTPS_PROXY=http://ssrf_proxy:3128
```

## Datasources

```env
# Configurações de datasources web
ENABLE_WEBSITE_JINAREADER=true    # Padrão: true
ENABLE_WEBSITE_FIRECRAWL=true     # Padrão: true
ENABLE_WEBSITE_WATERCRAWL=true    # Padrão: true
```

## Tarefas Agendadas (Celery Schedule)

```env
# Habilitar/desabilitar tarefas
ENABLE_CLEAN_EMBEDDING_CACHE_TASK=false      # Padrão: false
ENABLE_CLEAN_UNUSED_DATASETS_TASK=false      # Padrão: false
ENABLE_CREATE_TIDB_SERVERLESS_TASK=false     # Padrão: false
ENABLE_UPDATE_TIDB_SERVERLESS_STATUS_TASK=false  # Padrão: false
ENABLE_CLEAN_MESSAGES=false                  # Padrão: false
ENABLE_MAIL_CLEAN_DOCUMENT_NOTIFY_TASK=false # Padrão: false
ENABLE_DATASETS_QUEUE_MONITOR=false          # Padrão: false
ENABLE_CHECK_UPGRADABLE_PLUGIN_TASK=true     # Padrão: true

# TiDB service job
CREATE_TIDB_SERVICE_JOB_ENABLED=false        # Padrão: false
```

## Monitoramento de Filas

```env
# Limite de alerta para fila de datasets
QUEUE_MONITOR_THRESHOLD=200      # Padrão: 200

# Emails para alertas (separados por vírgula)
# Ex: admin1@dify.ai,admin2@dify.ai
QUEUE_MONITOR_ALERT_EMAILS=

# Intervalo de monitoramento em minutos
QUEUE_MONITOR_INTERVAL=30        # Padrão: 30
```

## Swagger UI

```env
# Habilitar/desabilitar Swagger UI
SWAGGER_UI_ENABLED=true          # Padrão: true

# Caminho do Swagger UI
SWAGGER_UI_PATH=/swagger-ui.html  # Padrão: /swagger-ui.html
```

## Telemetria

```env
# Next.js telemetria
NEXT_TELEMETRY_DISABLED=1        # Padrão: 0 (habilitado)

# PM2 instances (para frontend)
PM2_INSTANCES=2                  # Padrão: 2
```

## Configurações de Vector Stores Específicas

### MyScale
```env
MYSCALE_HOST=myscale
MYSCALE_PORT=8123
MYSCALE_USER=default
MYSCALE_PASSWORD=
MYSCALE_DATABASE=dify
MYSCALE_FTS_PARAMS=       # Parâmetros de full-text search
```

### Couchbase
```env
COUCHBASE_CONNECTION_STRING=couchbase://couchbase-server
COUCHBASE_USER=Administrator
COUCHBASE_PASSWORD=password
COUCHBASE_BUCKET_NAME=Embeddings
COUCHBASE_SCOPE_NAME=_default
```

### TiDB Vector
```env
TIDB_VECTOR_HOST=tidb
TIDB_VECTOR_PORT=4000
TIDB_VECTOR_USER=
TIDB_VECTOR_PASSWORD=
TIDB_VECTOR_DATABASE=dify
```

### AnalyticDB
```env
ANALYTICDB_KEY_ID=your-ak
ANALYTICDB_KEY_SECRET=your-sk
ANALYTICDB_REGION_ID=cn-hangzhou
ANALYTICDB_INSTANCE_ID=gp-ab123456
ANALYTICDB_ACCOUNT=testaccount
ANALYTICDB_PASSWORD=testpassword
ANALYTICDB_NAMESPACE=dify
ANALYTICDB_NAMESPACE_PASSWORD=difypassword
ANALYTICDB_HOST=gp-test.aliyuncs.com
ANALYTICDB_PORT=5432
ANALYTICDB_MIN_CONNECTION=1
ANALYTICDB_MAX_CONNECTION=5
```

### Oracle Vector
```env
ORACLE_USER=dify
ORACLE_PASSWORD=dify
ORACLE_DSN=oracle:1521/FREEPDB1
ORACLE_CONFIG_DIR=/app/api/storage/wallet
ORACLE_WALLET_LOCATION=/app/api/storage/wallet
ORACLE_WALLET_PASSWORD=dify
ORACLE_IS_AUTONOMOUS=false
ORACLE_PWD=Dify123456
ORACLE_CHARACTERSET=AL32UTF8
```

### ClickZetta
```env
CLICKZETTA_USERNAME=
CLICKZETTA_PASSWORD=
CLICKZETTA_INSTANCE=
CLICKZETTA_SERVICE=api.clickzetta.com
CLICKZETTA_WORKSPACE=quick_start
CLICKZETTA_VCLUSTER=default_ap
CLICKZETTA_SCHEMA=dify
CLICKZETTA_BATCH_SIZE=100
CLICKZETTA_ENABLE_INVERTED_INDEX=true
CLICKZETTA_ANALYZER_TYPE=chinese
CLICKZETTA_ANALYZER_MODE=smart
CLICKZETTA_VECTOR_DISTANCE_FUNCTION=cosine_distance
```

## Docker Compose Profiles

```env
# Perfil padrão baseado no vector store
# Se quiser usar unstructured, adicione ',unstructured' ao final
COMPOSE_PROFILES=${VECTOR_STORE:-weaviate}
```

---

## 📝 Notas Importantes

1. **Variáveis Críticas**: Sempre configure `SECRET_KEY`, credenciais de banco de dados e chaves de API antes de usar em produção.

2. **Valores Padrão**: A maioria das variáveis tem valores padrão sensatos. Configure apenas o que precisa mudar.

3. **Segurança**: 
   - Nunca commite arquivos `.env` com valores reais no Git
   - Use secrets management em produção
   - Gere chaves fortes para `SECRET_KEY` e tokens

4. **Performance**: Ajuste workers, timeouts e limites baseado no seu hardware e carga esperada.

5. **Vector Store**: Escolha apenas um vector store e configure suas variáveis específicas.

6. **Armazenamento**: Para produção, considere usar cloud storage (S3, Azure, etc.) ao invés de local.

7. **Monitoramento**: Configure Sentry e OpenTelemetry para observabilidade em produção.

8. **Email**: Configure SMTP ou provedor de email para funcionalidades como convites e reset de senha.
