#!/bin/bash

# Verificar permissão
if [ "$EUID" -ne 0 ]; then
  echo "❌ Por favor, execute como root: sudo ./instalador.sh"
  exit 1
fi

clear
echo "============================================================"
echo "     🚀 INSTALADOR AUTOMÁTICO - DIFY + DOCKER 🚀"
echo "     Contato: (21)98496-8082 | Email: andre.rj.tj@gmail.com"
echo "     Por: André Azambuja (@andrecoruja)"
echo "============================================================"
sleep 2

# INSTALAÇÃO DO GIT
echo "🔧 INICIANDO A INSTALAÇÃO DO GIT..."
sudo apt update && sudo apt install git -y

# INSTALAÇÃO DO DOCKER E DOCKER COMPOSE
echo ""
echo "🐳 INICIANDO A INSTALAÇÃO DO DOCKER E DOCKER COMPOSE..."
sleep 5
echo "📥 Baixando e executando script oficial do Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Criando acme.json e ajustando permissões
echo ""
echo "🛡️ Criando acme.json e ajustando permissões..."
touch acme.json
sudo chmod 600 acme.json

# Instalando utilitário apache2-utils
echo ""
echo "⚙️ Instalando utilitário apache2-utils..."
sudo apt-get install apache2-utils -y

# Clonando repositório do Dify
echo ""
echo "📦 CLONANDO O REPOSITÓRIO DO DIFY..."
git clone https://github.com/langgenius/dify.git

# Entrando na pasta do Docker
echo ""
echo "📁 ENTRANDO NA PASTA docker DO DIFY..."
cd dify/docker || { echo "❌ Erro ao acessar a pasta dify/docker"; exit 1; }

# Copiar o arquivo .env
echo ""
echo "⚙️ COPIANDO O ARQUIVO DE CONFIGURAÇÃO .env..."
cp .env.example .env

# Informar ajustes manuais no .env
echo ""
echo "⚠️  AGORA, EDITE O ARQUIVO .env PARA DEFINIR AS VARIÁVEIS:"
echo "    - Altere VECTOR_STORE para: VECTOR_STORE=milvus"
echo "    - Configure:"
echo "        MILVUS_URI=xxx"
echo "        MILVUS_TOKEN=xxx"
echo ""
read -p "Pressione ENTER após configurar o arquivo .env para continuar..."

# Iniciar os contêineres Docker
echo ""
echo "🚀 INICIANDO OS CONTÊINERES DOCKER..."
docker compose up -d

# Finalização
IP=$(hostname -I | awk '{print $1}')
echo ""
echo "✅ INSTALAÇÃO FINALIZADA COM SUCESSO!"
echo "🌐 Abra o navegador e acesse: http://$IP"
echo ""
