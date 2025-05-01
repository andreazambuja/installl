#!/bin/bash

# Verificar se script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Por favor, execute este script como root (use: sudo ./nome_do_script.sh)"
  exit 1
fi

clear
echo "============================================================"
echo "        🚀 INSTALADOR AUTOMÁTICO - DOCKER + DIFY 🚀"
echo "        Contato: (21)98496-8082 | Email: andre.rj.tj@gmail.com"
echo "        Por: André Azambuja (@andrecoruja)"
echo "============================================================"
sleep 2

# Atualizar pacotes
echo "🔄 Atualizando pacotes..."
apt update && apt upgrade -y

# Instalar Git, se necessário
echo "🔧 Verificando instalação do Git..."
if ! command -v git &> /dev/null; then
  echo "📦 Instalando Git..."
  apt install git -y
else
  echo "✅ Git já está instalado."
fi

# Instalar pacotes essenciais
echo "📦 Instalando pacotes essenciais..."
apt install -y apt-transport-https ca-certificates curl software-properties-common apache2-utils gnupg lsb-release

# Adicionar chave GPG do Docker
echo "🔐 Adicionando chave GPG do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adicionar repositório Docker
echo "📁 Adicionando repositório Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualizar pacotes novamente
echo "🔄 Atualizando pacotes novamente..."
apt update

# Instalar Docker
echo "🐳 Instalando Docker..."
apt install -y docker-ce docker-ce-cli containerd.io

# Instalar Docker Compose via script oficial
echo "📦 Instalando Docker Compose..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Habilitar e iniciar Docker
systemctl enable docker
systemctl start docker

# Criar acme.json com permissão segura
echo "🛡️ Criando acme.json com permissão..."
touch acme.json
chmod 600 acme.json

# Clonar repositório do Dify
echo "📥 Clonando Dify (última versão)..."
git clone https://github.com/langgenius/dify.git
cd dify/docker || exit

# Copiar arquivo de ambiente
echo "⚙️ Preparando ambiente..."
cp .env.example .env

# Iniciar containers
echo "🚀 Iniciando containers..."
docker compose up -d

# Exibir IP do servidor
IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "🌐 Acesse seu Dify em: http://$IP:porta_configurada_no_env"
