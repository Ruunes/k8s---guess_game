# Guess Game - Kubernetes + Helm + k3d

Projeto desenvolvido para a disciplina de **Conteinerização e Orquestração** da **PUC Minas**.

Este trabalho é a continuação da primeira etapa do projeto, onde inicialmente foi realizada apenas a conteinerização da aplicação utilizando Docker.  
Nesta nova etapa, o ambiente foi reestruturado utilizando Kubernetes, adicionando recursos de orquestração, persistência, escalabilidade automática e gerenciamento com Helm Charts.

---

# Objetivo do projeto

O objetivo deste projeto é demonstrar a implantação de uma aplicação completa utilizando Kubernetes local com k3d, contendo:

- Frontend React
- Backend Flask
- Banco PostgreSQL
- Persistência de dados
- Escalabilidade automática com HPA
- Deploy automatizado com Helm

---

# Arquitetura

```text
Frontend (React + Nginx)
        ↓
Backend (Flask API)
        ↓
PostgreSQL
```

---

# Tecnologias utilizadas

| Tecnologia | Função |
|---|---|
| Docker | Containerização |
| Kubernetes | Orquestração |
| k3d | Cluster Kubernetes local |
| Helm | Gerenciamento dos manifests |
| React | Frontend |
| Flask | Backend |
| PostgreSQL | Banco de dados |
| HPA | Escalabilidade automática |

---

# Estrutura do projeto

```text
guess-game-k8s/
│
├── backend/
│   ├── guess/
│   ├── repository/
│   ├── tests/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── run.py
│
├── db/
│   └── init.sql
│
├── frontend/
│   ├── public/
│   ├── src/
│   ├── nginx.conf
│   ├── Dockerfile
│   └── package.json
│
├── guess-game-chart/
│   ├── templates/
│   ├── Chart.yaml
│   └── values.yaml
│
├── docker-compose.yml
├── README.md
└── start-backend.sh
```

---

# Pré-requisitos

Antes de iniciar, é necessário possuir os softwares abaixo instalados:

---

## Docker

Instalação:

https://www.docker.com/products/docker-desktop/

Verificar instalação:

```bash
docker --version
```

---

## kubectl

Instalação:

https://kubernetes.io/docs/tasks/tools/

Verificar instalação:

```bash
kubectl version --client
```

---

## k3d

Instalação:

https://k3d.io/

Verificar instalação:

```bash
k3d version
```

---

## Helm

Instalação:

https://helm.sh/docs/intro/install/

Verificar instalação:

```bash
helm version
```

---

# IMPORTANTE

A porta abaixo precisa estar livre na máquina:

```text
8080
```

Ela será utilizada para acessar o Frontend da aplicação.

---

# Docker Hub

As imagens utilizadas no projeto estão publicadas no Docker Hub e são baixadas automaticamente pelo Kubernetes.

---

# Passo a passo para subir o projeto

# 1. Clonar o projeto

```bash
git clone <URL_DO_REPOSITORIO>
```

Entrar na pasta:

```bash
cd guess-game-k8s
```

---

# 2. Criar cluster k3d

```bash
k3d cluster create guess-game -p "8080:30080@loadbalancer"
```

Verificar cluster:

```bash
k3d cluster list
```

---

# 3. Instalar Metrics Server

Necessário para funcionamento do HPA.

Instalar:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Editar deployment:

```bash
kubectl edit deployment metrics-server -n kube-system
```

Adicionar:

```yaml
- --kubelet-insecure-tls
```

Exemplo:

```yaml
containers:
- args:
  - --cert-dir=/tmp
  - --secure-port=10250
  - --kubelet-insecure-tls
```

Salvar e sair.

Verificar:

```bash
kubectl get deployment metrics-server -n kube-system
```

---

# 4. Instalar aplicação com Helm

Entrar na pasta do chart:

```bash
cd guess-game-chart
```

Validar chart:

```bash
helm lint .
```

Instalar aplicação:

```bash
helm install guess-game . -n guess-game --create-namespace
```

---

# 5. Verificar funcionamento

Verificar pods:

```bash
kubectl get pods -n guess-game
```

Resultado esperado:

```text
backend
frontend
postgres
```

Verificar serviços:

```bash
kubectl get svc -n guess-game
```

Verificar HPA:

```bash
kubectl get hpa -n guess-game
```

---

# 6. Acessar aplicação

Abrir navegador:

```text
http://localhost:8080
```

---

# Persistência

O PostgreSQL utiliza PersistentVolumeClaim (PVC).

Mesmo reiniciando o pod do banco, os dados permanecem salvos.

Verificar PVC:

```bash
kubectl get pvc -n guess-game
```

---

# Escalabilidade automática

O backend utiliza Horizontal Pod Autoscaler (HPA).

Verificar:

```bash
kubectl get hpa -n guess-game
```

---

# Reiniciar pods

## Reiniciar frontend

```bash
kubectl rollout restart deployment/frontend -n guess-game
```

## Reiniciar backend

```bash
kubectl rollout restart deployment/backend -n guess-game
```

## Reiniciar postgres

```bash
kubectl rollout restart deployment/postgres -n guess-game
```

---

# Remover ambiente

Remover aplicação:

```bash
helm uninstall guess-game -n guess-game
```

Remover cluster:

```bash
k3d cluster delete guess-game
```

---

# Ver logs do backend

```bash
kubectl logs deployment/backend -n guess-game
```

---

# Ver logs do frontend

```bash
kubectl logs deployment/frontend -n guess-game
```

---

# Ver logs do postgres

```bash
kubectl logs deployment/postgres -n guess-game
```

---

# Observações

- O projeto foi desenvolvido utilizando k3d local.
- O frontend é exposto utilizando NodePort.
- O backend é acessado internamente pelo frontend utilizando Service Kubernetes.
- O banco PostgreSQL utiliza persistência via PVC.
- O Helm foi utilizado para automatizar os manifests Kubernetes.
- O projeto é a continuação da primeira etapa da disciplina, onde anteriormente havia sido implementado apenas o ambiente Docker.
