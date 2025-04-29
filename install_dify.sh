#!/bin/bash

clear
echo "============================================================"
echo "        🚀 INSTALADOR AUTOMÁTICO - DOCKER + DIFY 🚀        "
echo "============================================================"
sleep 2

# Atualizar pacotes
echo "🔄 Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instalar pacotes essenciais
echo "📦 Instalando pacotes essenciais..."
sudo apt install apt-transport-https ca-certificates curl software-properties-common apache2-utils -y

# Adicionar chave GPG do Docker
echo "🔐 Adicionando chave GPG do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adicionar repositório Docker
echo "📁 Adicionando repositório Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualizar novamente
echo "🔄 Atualizando pacotes novamente..."
sudo apt update

# Instalar Docker
echo "🐳 Instalando Docker..."
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Instalar Docker Compose (caso necessário)
echo "📦 Instalando Docker Compose..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Criar acme.json e dar permissão
echo "🛡️ Criando acme.json com permissão..."
touch acme.json
sudo chmod 600 acme.json

# Clonar repositório do Dify
echo "📥 Clonando Dify (v0.15.3)..."
git clone https://github.com/langgenius/dify.git --branch 0.15.3
cd dify/docker

# Copiar .env de exemplo
echo "⚙️ Preparando ambiente..."
cp .env.example .env

# Subir os containers com Docker Compose
echo "🚀 Iniciando containers..."
docker compose up -d

echo ""
echo "✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "🌐 Acesse seu Dify via IP do servidor e a porta configurada no .env"
