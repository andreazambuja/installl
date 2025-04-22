🚀 Instalação Automática do Dify (v0.15.3) sem Certificado SSL
Este script foi criado para facilitar a instalação automática do Dify (versão 0.15.3) em servidores com sistema Linux (Ubuntu), sem a necessidade de configurar SSL (ideal para ambientes de testes ou redes internas)


✅ O que o script realiza:
Instala o Docker – Plataforma essencial para criar e gerenciar containers.

Instala o Docker Compose – Ferramenta para orquestrar múltiplos containers via arquivos .yml.

Cria e configura o arquivo acme.json – usado normalmente para certificados (neste caso, ainda sem uso de SSL).

Instala utilitários do Apache – necessários para autenticação, preparando o ambiente.

Clona o projeto oficial do Dify (v0.15.3) diretamente do GitHub.

Prepara o ambiente .env do Dify.

Inicializa o Dify com Docker Compose, deixando o sistema em funcionamento.


🛠️ Como rodar a instalação
Abra o terminal e execute os seguintes comandos:

bash
Copiar
Editar
git clone https://github.com/andreazambuja/installl.git
cd installl
chmod +x install_dify.sh
./install_dify.sh
Após isso, o Dify será instalado automaticamente e estará pronto para ser acessado via IP da sua VPS (porta padrão definida no docker-compose.yml)


📌 Observação:
Este instalador não configura o SSL. Ideal para ambientes de desenvolvimento ou para alunos testarem o sistema em rede local ou com domínios não protegidos.

📱 Dúvidas ou Suporte?
Entre em contato: (21) 98496-8082
