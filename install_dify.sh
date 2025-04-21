#!/bin/bash

# Atualizar o sistema
sudo apt-get update -y
sudo apt-get upgrade -y

# Instalar o Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Instalar o Docker Compose
sudo apt-get install -y docker-compose

# Criar o arquivo acme.json
touch acme.json

# Ajustar permissões do arquivo acme.json
sudo chmod 600 acme.json

# Instalar utilitário Apache (necessário para gerar SSL)
sudo apt-get install apache2-utils -y

# Clonar o repositório Dify
git clone https://github.com/langgenius/dify.git --branch 0.15.3

# Navegar até o diretório Docker do Dify
cd dify/docker

# Copiar o arquivo .env de exemplo
cp .env.example .env

# Rodar o Docker Compose
docker-compose up -d

# Mensagem de conclusão
echo "Instalação concluída com sucesso!"
