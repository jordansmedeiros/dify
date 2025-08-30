# Deploy do Dify no CapRover

Este guia fornece instruções detalhadas para realizar o deploy do Dify no CapRover usando GitHub como método de deploy.

## 📋 Pré-requisitos

- CapRover instalado e configurado
- Conta no GitHub com o fork do Dify
- PostgreSQL configurado (pode ser no CapRover ou externo)
- Domínio configurado no CapRover (opcional, mas recomendado)

## 🗄️ Passo 1: Configurar PostgreSQL no CapRover

### Opção A: Usar PostgreSQL One-Click App

1. No painel do CapRover, vá para "Apps"
2. Clique em "One-Click Apps/Databases"
3. Procure por "PostgreSQL" e instale
4. Anote as credenciais fornecidas:
   - Nome do app (será usado como DB_HOST)
   - Usuário (geralmente `postgres`)
   - Senha
   - Banco de dados (geralmente `postgres`)

### Opção B: Usar PostgreSQL Externo

Se você já tem um PostgreSQL configurado, apenas anote as credenciais de conexão.

## 🚀 Passo 2: Criar o App Dify no CapRover

1. No painel do CapRover, clique em "Apps"
2. Clique em "Create New App"
3. Digite um nome para o app (ex: `dify`)
4. Marque "Has Persistent Data" se quiser persistir os dados
5. Clique em "Create New App"

## ⚙️ Passo 3: Configurar Variáveis de Ambiente

No app criado, vá para a aba "App Configs" e adicione as seguintes variáveis de ambiente:

### Variáveis Obrigatórias

```env
# Banco de Dados (ajuste conforme seu PostgreSQL)
DB_HOST=srv-captain--postgres-db  # Nome do app PostgreSQL no CapRover
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=sua_senha_postgres
DB_DATABASE=dify

# Segurança - IMPORTANTE: Gere uma chave única!
SECRET_KEY=sk-gere-uma-chave-forte-aqui-use-openssl-rand-base64-42

# Redis (usa Redis embutido)
REDIS_PASSWORD=difyai123456

# URLs da Aplicação (ajuste para seu domínio)
CONSOLE_API_URL=https://seu-dominio.com
CONSOLE_WEB_URL=https://seu-dominio.com
SERVICE_API_URL=https://seu-dominio.com
APP_API_URL=https://seu-dominio.com
APP_WEB_URL=https://seu-dominio.com
FILES_URL=https://seu-dominio.com

# Configurações de Migração
MIGRATION_ENABLED=true
```

### Variáveis Opcionais Recomendadas

```env
# Performance
SERVER_WORKER_AMOUNT=2
GUNICORN_TIMEOUT=360
PM2_INSTANCES=2

# Limites de Upload
UPLOAD_FILE_SIZE_LIMIT=15
UPLOAD_FILE_BATCH_LIMIT=5
UPLOAD_IMAGE_FILE_SIZE_LIMIT=10
UPLOAD_VIDEO_FILE_SIZE_LIMIT=100
UPLOAD_AUDIO_FILE_SIZE_LIMIT=50

# Vector Store (padrão: weaviate embutido)
VECTOR_STORE=weaviate

# Logs
LOG_LEVEL=INFO

# Ambiente
DEPLOY_ENV=PRODUCTION

# Email (opcional, configure se quiser enviar emails)
MAIL_TYPE=smtp
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=seu-email@gmail.com
SMTP_PASSWORD=sua-senha-app
MAIL_DEFAULT_SEND_FROM=seu-email@gmail.com
```

### Variáveis para Modelos de IA

Configure as chaves API dos modelos que deseja usar:

```env
# OpenAI
OPENAI_API_KEY=sk-...

# Anthropic (Claude)
ANTHROPIC_API_KEY=sk-ant-...

# Google (Gemini)
GOOGLE_API_KEY=...

# Adicione outras conforme necessário
```

## 🔗 Passo 4: Configurar Deploy via GitHub

1. Na aba "Deployment" do app no CapRover
2. Selecione "Method 3: Deploy from GitHub"
3. Siga as instruções para conectar seu repositório:
   - Adicione o webhook no GitHub
   - Configure o branch (geralmente `main` ou `master`)
   - Configure o caminho do repositório (deixe vazio para raiz)

## 📦 Passo 5: Fazer o Deploy

### Método 1: Deploy Automático (Recomendado)

1. Faça um commit e push para o branch configurado:
```bash
git add .
git commit -m "Deploy Dify no CapRover"
git push origin main
```

2. O CapRover detectará automaticamente o push e iniciará o build

### Método 2: Deploy Manual

1. No CapRover, vá para a aba "Deployment"
2. Clique em "Deploy Now"

## ✅ Passo 6: Verificar o Deploy

1. Acompanhe os logs de build na aba "Deployment"
2. O processo pode levar 10-20 minutos na primeira vez
3. Após o sucesso, acesse `https://seu-app.seu-dominio.com/install`
4. Complete a configuração inicial do Dify

## 🔧 Configurações Adicionais

### Habilitar HTTPS

1. Na aba "HTTP Settings"
2. Ative "Enable HTTPS"
3. Marque "Force HTTPS"
4. Selecione seu domínio

### Configurar Persistência de Dados

1. Na aba "App Configs"
2. Em "Persistent Directories", adicione:

   **Primeira linha:**
   - Caminho no App: `/app/storage`
   - Rótulo: `storage`
   - Definir caminho específico no host: (deixe vazio para usar padrão)

   **Segunda linha:**
   - Caminho no App: `/app/logs`
   - Rótulo: `logs`
   - Definir caminho específico no host: (deixe vazio para usar padrão)

   **Terceira linha (opcional mas recomendado):**
   - Caminho no App: `/var/lib/postgresql/data`
   - Rótulo: `postgres-data`
   - Definir caminho específico no host: (deixe vazio para usar padrão)
   
   > **Nota**: Os rótulos são importantes pois o CapRover usa eles para criar volumes Docker nomeados. Isso facilita backup e migração dos dados.

### Configurar Recursos

1. Na aba "App Configs"
2. Em "Service Update Override", você pode ajustar:
```json
{
  "TaskTemplate": {
    "Resources": {
      "Limits": {
        "Memory": 4294967296,  // 4GB
        "CPU": 2                // 2 CPUs
      }
    }
  }
}
```

## 🐛 Troubleshooting

### Erro de Conexão com PostgreSQL

- Verifique se o PostgreSQL está rodando
- Confirme as credenciais nas variáveis de ambiente
- Se usar PostgreSQL do CapRover, o host deve ser `srv-captain--nome-do-app-postgres`

### Build Falha com Erro de Memória

- Aumente os recursos do app (veja "Configurar Recursos")
- Considere fazer o build localmente e fazer push da imagem

### Aplicação não Inicia

- Verifique os logs em "App Logs"
- Confirme que todas as variáveis obrigatórias estão configuradas
- Verifique se a SECRET_KEY está configurada corretamente

### Erro 502 Bad Gateway

- Aguarde alguns minutos após o deploy para os serviços iniciarem
- Verifique os logs para erros específicos
- Confirme que as portas estão configuradas corretamente

## 📝 Notas Importantes

1. **SECRET_KEY**: SEMPRE gere uma chave única para produção. Use:
   ```bash
   openssl rand -base64 42
   ```

2. **Banco de Dados**: Este setup usa PostgreSQL externo. O Redis está embutido no container para simplificar.

3. **Recursos Mínimos**: 
   - RAM: 4GB (recomendado 8GB)
   - CPU: 2 cores (recomendado 4 cores)
   - Disco: 20GB+

4. **Backup**: Configure backups regulares do PostgreSQL e do diretório `/app/storage`

5. **Monitoramento**: Use os logs do CapRover e considere configurar Sentry para monitoramento de erros:
   ```env
   SENTRY_DSN=sua-url-sentry
   ```

## 🔄 Atualizações

Para atualizar o Dify:

1. Faça pull das atualizações do repositório original
2. Resolva conflitos se necessário
3. Faça push para seu fork
4. O CapRover fará o deploy automaticamente

## 🆘 Suporte

- [Documentação do Dify](https://docs.dify.ai)
- [Documentação do CapRover](https://caprover.com/docs)
- [GitHub Issues do Dify](https://github.com/langgenius/dify/issues)

## 📌 Checklist de Deploy

- [ ] PostgreSQL configurado e acessível
- [ ] App criado no CapRover
- [ ] Variáveis de ambiente configuradas
- [ ] SECRET_KEY gerada e configurada
- [ ] GitHub conectado ao CapRover
- [ ] Deploy realizado com sucesso
- [ ] HTTPS habilitado
- [ ] Persistência configurada
- [ ] Backup configurado
- [ ] Aplicação acessível e funcionando
