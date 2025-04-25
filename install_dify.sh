#!/bin/bash
set -e

# ███████╗██╗███████╗██╗   ██╗
# ██╔════╝██║██╔════╝╚██╗ ██╔╝
# █████╗  ██║█████╗   ╚████╔╝ 
# ██╔══╝  ██║██╔══╝    ╚██╔╝  
# ██║     ██║███████╗   ██║   
# ╚═╝     ╚═╝╚══════╝   ╚═╝   
#  🚀 Script de Instalação Automática do Dify AI - by UP Tecnologia 🚀
# ================================================================
# Este script instala o Dify, configura Docker, NGINX e HTTPS
# ================================================================

# --- Variáveis ---
DIFY_DIR="/opt/dify"
DOMAIN_WEB="dify.uptecnologia.online"
DOMAIN_API="dfapi.uptecnologia.online"

echo "🚀 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "🐳 Instalando Docker + Compose..."
sudo apt install -y ca-certificates curl gnupg lsb-release nginx

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "🔁 Habilitando Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "📁 Clonando Dify..."
sudo git clone https://github.com/langgenius/dify.git --branch 0.15.3 $DIFY_DIR

echo "📁 Configurando ambiente..."
cd $DIFY_DIR/docker
sudo cp .env.example .env

sudo sed -i "s|^CONSOLE_WEB_URL=.*|CONSOLE_WEB_URL=https://$DOMAIN_WEB|" .env
sudo sed -i "s|^SERVICE_API_URL=.*|SERVICE_API_URL=https://$DOMAIN_API|" .env
sudo sed -i "s|^APP_WEB_URL=.*|APP_WEB_URL=https://$DOMAIN_WEB|" .env
sudo sed -i "s|^APP_API_URL=.*|APP_API_URL=https://$DOMAIN_API|" .env

echo "📦 Subindo containers..."
sudo docker compose up -d

echo "🌐 Configurando NGINX..."
sudo mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled

# Adiciona include no nginx.conf se não existir
grep -qxF 'include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf || \
sudo sed -i '/http {/a \    include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf

# Configura site WEB
sudo tee /etc/nginx/sites-available/$DOMAIN_WEB > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN_WEB;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Configura site API
sudo tee /etc/nginx/sites-available/$DOMAIN_API > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN_API;

    location / {
        proxy_pass http://localhost:5001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/$DOMAIN_WEB /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/$DOMAIN_API /etc/nginx/sites-enabled/

echo "✅ Testando e reiniciando NGINX..."
sudo nginx -t && sudo systemctl reload nginx

echo "🔐 Instalando Certbot e HTTPS..."
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --non-interactive --agree-tos --nginx -d $DOMAIN_WEB -d $DOMAIN_API -m admin@$DOMAIN_WEB

echo "🎉 INSTALAÇÃO COMPLETA!"
echo "Acesse:"
echo "Frontend: https://$DOMAIN_WEB"
echo "API: https://$DOMAIN_API"
