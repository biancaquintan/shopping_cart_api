# Carrinho de Compras Online - API REST

Uma API RESTful desenvolvida em Ruby on Rails para gerenciamento de um carrinho de compras em um e-commerce.

## ✨ Funcionalidades

* Adicionar produtos ao carrinho
* Atualizar a quantidade de produtos
* Remover produtos do carrinho
* Visualizar itens do carrinho
* Marcar como abandonado carrinhos inativos
* Remover carrinhos abandonados

## 📚 Endpoints Principais

### 1. Criar ou adicionar produto ao carrinho

**POST** `/api/v1/carts`

Se não existir um carrinho, cria um e adiciona o produto.

#### Payload:

```json
{
  "product_id": 345,
  "quantity": 2
}
```

#### Resposta:

```json
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 3.98
}
```

### 2. Atualizar a quantidade de um produto no carrinho

**POST** `/api/v1/carts/add_item`

Se o produto já existir no carrinho, apenas incrementa a quantidade.

#### Payload:

```json
{
  "product_id": 1230,
  "quantity": 1
}
```

#### Resposta:

```json
{
  "id": 1,
  "products": [
    {
      "id": 1230,
      "name": "Nome do produto X",
      "quantity": 2,
      "unit_price": 7.00,
      "total_price": 14.00
    }
  ],
  "total_price": 14.00
}
```

### 3. Remover produto do carrinho

**DELETE** `/api/v1/carts/:product_id`

#### Resposta (carrinho atualizado):

```json
{
  "id": 1,
  "products": [],
  "total_price": 0.0
}
```

### 4. Visualizar o carrinho atual

**GET** `/api/v1/carts`

#### Resposta:

```json
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Produto X",
      "quantity": 2,
      "unit_price": 5.0,
      "total_price": 10.0
    }
  ],
  "total_price": 10.0
}
```

### 5. Gerenciamento de carrinhos abandonados

Carrinhos sem interação há mais de **3 horas** são marcados com `abandoned_at`, e carrinhos com `abandoned_at <= 7 dias atrás` são excluídos.

#### Implementação:

O job `MarkCartAsAbandonedJob` roda automaticamente com Sidekiq, conforme definido no `sidekiq.yml`:

```yaml
:schedule:
  mark_cart_as_abandoned_job:
    cron: '0 * * * *' # a cada hora
    class: 'MarkCartAsAbandonedJob'
```

Também é possível executar manualmente através da rake task:

```bash
bundle exec rake carts:mark_and_cleanup_abandoned
```

---

## ⚙️ Instalação e Execução

### Informações Técnicas

**Dependências:**

* Ruby 3.3.1
* Rails 7.1.3.2
* PostgreSQL 16
* Redis 7.0.15

---

## 🔐 Configuração de variáveis de ambiente

Este projeto utiliza um arquivo `.env` para armazenar configurações sensíveis.  
Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_HOST=
POSTGRES_PORT=
DEVELOP_DATABASE_URL=
TEST_DATABASE_URL=
PROD_DATABASE_URL=
VERBOSE_TEST_LOGS=

```
---

## Como executar o projeto

Dado que todas as as ferramentas estão instaladas e configuradas:

Instalar as dependências do:
```bash
bundle install
```

Executar o sidekiq:
```bash
bundle exec sidekiq
```

Executar projeto:
```bash
bundle exec rails server
```

Executar os testes:
```bash
bundle exec rspec
```

