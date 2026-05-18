# Guess Game - Docker Compose

## 📌 Descrição

Este projeto implementa o jogo **Guess Game** utilizando uma arquitetura baseada em containers com Docker Compose.

A aplicação é composta por:
- Backend em Python (Flask)
- Frontend em React
- Banco de dados PostgreSQL
- NGINX como proxy reverso e balanceador de carga

---

## 🏗️ Arquitetura

A aplicação foi estruturada utilizando múltiplos serviços orquestrados pelo Docker Compose:

[ Cliente ] -> [ NGINX (Proxy Reverso + Frontend) ] -> [ Backend (Flask - múltiplas instâncias) ] -> [ PostgreSQL ]

---

## 📁 Estrutura do Repositório
```
guess_game/
├─ backend/
├─ frontend/
├─ nginx/
├─ db/
├─ docker-compose.yml
└─ README.md
```
---

## ⚙️ Serviços

### 🔹 Backend (Flask)
- Responsável pela lógica do jogo
- Conecta ao PostgreSQL
- Pode ser escalado horizontalmente
- Roda internamente na porta **5000**

---

### 🔹 Frontend (React)
- Interface do usuário
- Buildado e servido via NGINX

---

### 🔹 NGINX
- Atua como proxy reverso
- Faz balanceamento de carga entre múltiplas instâncias do backend (round-robin)
- Serve os arquivos estáticos do frontend

---

### 🔹 PostgreSQL
- Armazena os dados do jogo
- Utiliza volume persistente
- Inicializado automaticamente via `db/init.sql`

---

## 🧠 Decisões de Design

### 🔹 Docker Compose
Utilizado para orquestrar todos os serviços, permitindo fácil gerenciamento e reprodução do ambiente.

---

### 🔹 Separação de Containers
Cada componente roda em seu próprio container:
- Backend
- Frontend
- Banco
- Proxy

Isso garante:
- Isolamento
- Escalabilidade
- Facilidade de manutenção

---

### 🔹 Comunicação entre Containers
Os containers se comunicam utilizando DNS interno do Docker Compose.

Exemplo:
- O backend acessa o banco usando o hostname: `db`

---

### 🔹 Inicialização do Banco

A criação da tabela não é feita pelos containers do backend para evitar problemas de concorrência em ambientes com múltiplas instâncias.

Em vez disso, é utilizado um script `init.sql`, executado automaticamente pelo PostgreSQL na primeira inicialização.

---

### 🔹 Volume Persistente (Banco)

O banco utiliza volume Docker:

postgres_data:/var/lib/postgresql/data


Garantindo persistência dos dados mesmo após reinício dos containers.

---

### 🔹 Balanceamento de Carga

O NGINX distribui as requisições entre múltiplas instâncias do backend utilizando **round-robin**.

Exemplo:
- backend-1
- backend-2
- backend-3

---

### 🔹 Resiliência

Todos os containers utilizam:

restart: always


Garantindo reinicialização automática em caso de falha.

---

### 🔹 Escalabilidade

O número de instâncias do backend pode ser alterado dinamicamente:

```bash
docker-compose up --scale backend=3
```
---

## 🔹 Ordem de Inicialização

O backend depende do banco de dados utilizando healthcheck, garantindo que só será iniciado após o banco estar pronto para conexões.

### 🚀 Como Executar
📋 Pré-requisitos:
 - Docker
 - Docker Compose
### ▶️ Subir a aplicação:
```bash
docker-compose up --build --scale backend=3
```
### 🌐 Acesso
A aplicação estará disponível em:

```bash
http://localhost
```

---

## 🧪 Teste de Funcionamento

Após subir a aplicação:

- Acesse http://localhost
- Inicie um jogo
- Verifique que múltiplas requisições são distribuídas entre os backends

### Opcional:
```bash
docker ps
```
### 🛑 Parar a aplicação:
```bash
docker-compose down
```
### 🔄 Reset completo (incluindo banco):
```bash
docker-compose down -v
```

## ⚠️ Observações Importantes

🔹 Porta 80
- A aplicação utiliza a porta 80 do host.

Certifique-se de que:
 - Nenhum outro serviço (IIS, Apache, outro NGINX) esteja utilizando essa porta
 - Caso necessário, altere no docker-compose.yml

ports:
  - "8080:80"

🔹 Ambiente

 - Compatível com Linux, Mac e Windows
 - Em Windows, recomenda-se uso de WSL2


---

## 🔄 Atualização dos Serviços

A arquitetura permite atualização independente de cada componente apenas alterando a imagem ou build.

🔹 Backend
- Alterar código ou imagem no Dockerfile
- Rebuild:
```bash
docker-compose up --build backend
```

🔹 Frontend
- Alterar código React
- Rebuild:
```bash
docker-compose up --build frontend
```

🔹 Banco de Dados
- Alterar versão da imagem no docker-compose.yml:
```
image: postgres:15
```

🔹 NGINX
- Alterar configuração em nginx.conf
- Rebuild:
```bash
docker-compose up --build nginx
```
---

## 📌 Conclusão

Este projeto atende aos requisitos propostos, incluindo:

- Orquestração com Docker Compose
- Persistência de dados
- Balanceamento de carga
- Escalabilidade horizontal
- Resiliência a falhas
- Facilidade de manutenção e atualização

---

## 📚 Referências

- Docker Documentation  
  https://docs.docker.com/

- Docker Compose Documentation  
  https://docs.docker.com/compose/

- PostgreSQL Official Documentation  
  https://www.postgresql.org/docs/

- NGINX Documentation  
  https://nginx.org/en/docs/

- Flask Documentation  
  https://flask.palletsprojects.com/

- React Documentation  
  https://react.dev/

- Repositório base do projeto  
  https://github.com/fams/guess_game