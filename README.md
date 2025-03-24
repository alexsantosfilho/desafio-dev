# Desafio Programação - Para Vaga Desenvolvedor

Este documento descreve o projeto desenvolvido para o desafio de programação, que consiste em uma aplicação Ruby on Rails para processar arquivos CNAB e armazenar transações financeiras em um banco de dados. A aplicação também exibe uma lista de transações por loja, incluindo o saldo total.

---

## Índice
1. [Visão Geral](#visão-geral)
2. [Estrutura do Projeto](#estrutura-do-projeto)
3. [Configuração do Ambiente](#configuração-do-ambiente)
4. [Endpoints da API](#endpoints-da-api)
5. [Exemplos de Uso](#exemplos-de-uso)
6. [Testes](#testes)
7. [Docker](#docker)
8. [Considerações Finais](#considerações-finais)
9. [Novas Tecnologias Utilizadas](#novas-tecnologias-utilizadas)

---

## Visão Geral
Este projeto é uma aplicação web desenvolvida em Ruby on Rails que permite o upload de arquivos CNAB (Controle Nacional de Automação Bancária) para processar transações financeiras de lojas. A aplicação faz o parse do arquivo, normaliza os dados e os armazena em um banco de dados PostgreSQL. Além disso, a aplicação exibe uma lista de transações por loja, incluindo o saldo total.

---

## Estrutura do Projeto

### Models
- **Store**: Representa uma loja e contém informações como nome e saldo.
  - **Atributos**: `name`, `owner`, `balance`.
  - **Relacionamento**: `has_many :transactions`.

- **Transaction**: Representa uma transação financeira.
  - **Atributos**: `transaction_type`, `date`, `value`, `cpf`, `card`, `hour`, `store_id`.
  - **Relacionamento**: `belongs_to :store`.

- **User**: Representa um usuário do sistema.
  - **Atributos**: `email`, `password_digest`, `provider`, `uid`.
  - **Relacionamento**: `has_many :sessions`.

- **Session**: Representa uma sessão de usuário.
  - **Atributos**: `user_id`, `token`.
  - **Relacionamento**: `belongs_to :user`.

### Controllers
- **TransactionsController**:
  - `index`: Exibe a lista de transações por loja.
  - `import`: Processa o arquivo CNAB e salva as transações no banco de dados(Job solid_cache e solid_queue).

- **SessionsController**:
  - `create`: Cria uma nova sessão de usuário.
  - `destroy`: Encerra a sessão do usuário.
  - `omniauth`: Lida com o callback de autenticação OAuth.


### Services
- **CnabParserService**: Faz o parse do arquivo CNAB e retorna uma lista de transações normalizadas.

### Views
- **transactions/index.html.erb**: Exibe a lista de transações por loja e o saldo total.

### Rotas
As rotas foram atualizadas para utilizar namespaces, versionamento da API, autenticação, gerenciamento de jobs e documentação da API com Swagger. Link api-doc(Swagger)
  ```
      http://localhost:3000/api-docs
   ```

Abaixo está a configuração atual das rotas:

```ruby
namespace :api do
  namespace :v1 do
    resource :session, only: [:create, :destroy]
    resources :passwords, param: :token, only: [:create, :update]

    resource :cnab, only: [] do
      post "import", to: "cnab#import", as: "import"
    end
    resources :transactions, only: [:index, :create]
    post "import", to: "transactions#import", as: "import_transactions"
  end
end

# Rotas para autenticação OAuth
get "/auth/failure", to: "sessions/omni_auths#failure", as: :omniauth_failure
get "/auth/:provider/callback", to: "sessions#omniauth", as: :omniauth_callback

# Rota para gerenciamento de jobs
mount MissionControl::Jobs::Engine, at: "/jobs"

# Rotas para documentação da API com Swagger UI
mount Rswag::Ui::Engine => "/api-docs"
mount Rswag::Api::Engine => "/api-docs"
```

#### Rotas Disponíveis
- **POST /api/v1/session**: Rota para criar uma nova sessão de usuário.
- **DELETE /api/v1/session**: Rota para encerrar a sessão do usuário.
- **POST /api/v1/passwords**: Rota para enviar um e-mail de redefinição de senha.
- **PATCH /api/v1/passwords/:token**: Rota para atualizar a senha do usuário.
- **POST /api/v1/cnab/import**: Rota para importar um arquivo CNAB.
- **GET /api/v1/transactions**: Rota para listar todas as transações.
- **POST /api/v1/transactions**: Rota para criar uma nova transação.
- **POST /api/v1/import_transactions**: Rota alternativa para importar transações.
- **GET /auth/failure**: Rota para lidar com falhas de autenticação OAuth.
- **GET /auth/:provider/callback**: Rota para lidar com o callback de autenticação OAuth.
- **GET /jobs**: Rota para acessar a interface de gerenciamento de jobs.
- **GET /api-docs**: Rota para acessar a documentação da API com Swagger UI.

---

## Overcommit no Rails
O **Overcommit** é uma ferramenta poderosa para automação de hooks de Git. Ela permite que você execute scripts e verificações antes de fazer commit, garantindo que o código siga padrões definidos e evitando a introdução de erros. No contexto do Ruby on Rails, o Overcommit pode ser configurado para rodar uma série de verificações úteis como:

- Verificação de estilo de código (usando `RuboCop`)
- Testes automatizados
- Análise de dependências
- Formatação do código (com `Prettier` ou `Standard`)

### Instalação do Overcommit
1. Adicione a gem ao seu Gemfile:
   ```ruby
   gem 'overcommit', require: false
   ```

2. Instale a gem:
   ```bash
   bundle install
   ```

3. Instale o Overcommit:
   ```bash
   overcommit --install
   ```

---

## Verificação de Segurança com Brakeman
O Brakeman foi utilizado para realizar uma análise estática de segurança no código do projeto. Abaixo estão os principais pontos verificados e os resultados obtidos:

### Resultados da Análise
1. **Vulnerabilidades de Injeção SQL**:
   - **Status**: Nenhuma vulnerabilidade de injeção SQL foi detectada.
   - **Recomendação**: Continuar utilizando métodos seguros de acesso ao banco de dados, como `ActiveRecord` queries.

2. **Cross-Site Scripting (XSS)**:
   - **Status**: Nenhuma vulnerabilidade de XSS foi detectada.
   - **Recomendação**: Manter a sanitização de dados de entrada e a utilização de helpers como `h()` para escapar conteúdo HTML.

3. **Cross-Site Request Forgery (CSRF)**:
   - **Status**: Proteção CSRF está habilitada por padrão no Rails.
   - **Recomendação**: Garantir que todas as requisições que modificam dados estejam protegidas por tokens CSRF.

4. **Exposição de Dados Sensíveis**:
   - **Status**: Nenhuma exposição de dados sensíveis foi detectada.
   - **Recomendação**: Continuar utilizando variáveis de ambiente para armazenar credenciais e informações sensíveis.

5. **Configurações de Segurança**:
   - **Status**: Configurações de segurança básicas estão corretas.
   - **Recomendação**: Revisar periodicamente as configurações de segurança do Rails e manter o framework atualizado.

### Como Executar o Brakeman
Para executar o Brakeman e verificar a segurança do código, execute no terminal do projeto o comando:
```bash
brakeman
```

---

## Testes Automatizados
Para rodar os testes automatizados, execute:
```bash
bundle exec rspec
```

---

## Configuração do Ambiente

## Docker
Para rodar a aplicação em um container Docker, siga os passos abaixo:

1. Construa a imagem:
   ```bash
   docker-compose build
   ```

2. Inicie os containers:
   ```bash
   docker-compose up
   ```

3. Acesse a aplicação em:
   ```
   http://localhost:3000
   ```

---

### Passos para Configuração(local)

### Pré-requisitos
- Ruby 3.4.2
- Rails 8.0.2
- PostgreSQL ou superior
- Docker (opcional)

1. Clone o repositório:
   ```bash
   git clone https://github.com/alexsantosfilho/desafio-dev.git
   cd desafio-dev
   ```

2. Instale as dependências:
   ```bash
   bundle install
   ```

3. Configure o banco de dados:
   - Crie o banco de dados:
     ```bash
     rails db:create
     ```
   - Execute as migrações:
     ```bash
     rails db:migrate
     ```
   - Execute a criação do Usuário:
     ```bash
     rails db:seed
     ```

4. Inicie o servidor:
   ```bash
   rails server
   ```

A aplicação estará disponível em `http://localhost:3000`.

### Acessando a Lista de Transações
Abra o navegador e acesse:
```
http://localhost:3000
```

---

## Novas Tecnologias Utilizadas

### Solid Cache, Solid Queue e Solid Cable
Neste projeto, optamos por utilizar as gems **Solid Cache**, **Solid Queue** e **Solid Cable** em vez das tradicionais **Redis** e **Sidekiq**. Essas gems são desenvolvidas pela equipe do Rails e oferecem soluções modernas e eficientes para caching, processamento de filas e comunicação em tempo real.

#### Solid Cache
- **Descrição**: O Solid Cache é uma solução de caching que utiliza o banco de dados PostgreSQL para armazenar dados em cache, eliminando a necessidade de um servidor Redis separado.
- **Link Oficial**: [Solid Cache](https://github.com/rails/solid_cache)

#### Solid Queue
- **Descrição**: O Solid Queue é um sistema de filas que utiliza o banco de dados PostgreSQL para gerenciar jobs em segundo plano, oferecendo uma alternativa ao Sidekiq.
- **Link Oficial**: [Solid Queue](https://github.com/rails/solid_queue)

#### Solid Cable
- **Descrição**: O Solid Cable é uma solução para comunicação em tempo real (WebSockets) que integra-se facilmente com o Rails, permitindo a criação de aplicações interativas.
- **Link Oficial**: [Solid Cable](https://github.com/rails/solid_cable)

---

### Hotwire e Turbo
Também utilizamos o **Hotwire** e o **Turbo** para criar interfaces de usuário modernas e responsivas sem a necessidade de escrever JavaScript complexo.

#### Hotwire
- **Descrição**: O Hotwire é uma abordagem moderna para desenvolvimento web que utiliza HTML sobre o wire, permitindo a criação de aplicações rápidas e responsivas.
- **Link Oficial**: [Hotwire](https://hotwired.dev/)

#### Turbo::StreamsChannel
- **Descrição**: O `Turbo::StreamsChannel` é utilizado para transmitir atualizações em tempo real para os clientes, permitindo a criação de funcionalidades como notificações em tempo real e atualizações dinâmicas de conteúdo.
- **Link Oficial**: [Turbo Streams](https://turbo.hotwired.dev/handbook/streams)

---

### Autenticação com OAuth e Novo Sistema de Autenticação do Rails
O projeto utiliza o novo sistema de autenticação do Rails, que inclui suporte para sessões, redefinição de senhas e autenticação OAuth (Google).

#### Autenticação Tradicional
- **Sessões**: As sessões são gerenciadas através do `resource :session`, permitindo login e logout.
- **Redefinição de Senha**: A redefinição de senha é gerenciada através do `resources :passwords`, com suporte a tokens.

#### Autenticação OAuth (Google)
- **OAuth**: A autenticação OAuth é implementada para permitir login via Google. As rotas `omniauth_failure` e `omniauth_callback` são utilizadas para lidar com falhas e sucessos na autenticação.

---

### Mission Control Jobs
Para gerenciar jobs de forma eficiente, utilizamos a gem **Mission Control Jobs**, que oferece uma interface web semelhante ao Sidekiq Web para monitorar e gerenciar jobs.

#### Mission Control Jobs
- **Descrição**: Mission Control Jobs é uma interface web para gerenciar jobs em background, integrando-se com o Solid Queue para fornecer uma experiência de gerenciamento de jobs semelhante ao Sidekiq.
- **Link Oficial**: [Mission Control Jobs](https://github.com/rails/mission_control-jobs)

#### Como Acessar
A interface de gerenciamento de jobs pode ser acessada em:
```
http://localhost:3000/jobs
```

---

### Documentação da API com Swagger UI
Para documentar a API de forma clara e interativa, utilizamos a gem **Rswag**, que integra o Swagger UI ao projeto Rails.

#### Rswag
- **Descrição**: Rswag é uma gem que permite gerar documentação da API no formato Swagger e disponibilizá-la através de uma interface web interativa.
- **Link Oficial**: [Rswag](https://github.com/rswag/rswag)

#### Como Acessar
A documentação da API pode ser acessada em:
```
http://localhost:3000/api-docs
```

---

## Considerações Finais
Este projeto foi desenvolvido com o objetivo de demonstrar habilidades técnicas em Ruby on Rails, incluindo a utilização de novas tecnologias como Solid Cache, Solid Queue, Solid Cable, Hotwire, Turbo, o novo sistema de autenticação do Rails, Mission Control Jobs e Rswag para documentação da API. A aplicação é escalável, segura e eficiente, atendendo aos requisitos do desafio proposto. As rotas foram atualizadas para seguir boas práticas de versionamento e organização de APIs, e a autenticação foi implementada com suporte a OAuth para maior flexibilidade e segurança. A interface de gerenciamento de jobs e a documentação da API oferecem uma experiência robusta para desenvolvedores e usuários.
# Instruções de entrega do desafio

1. Primeiro, faça um fork deste projeto para sua conta no Github (crie uma se você não possuir).
2. Em seguida, implemente o projeto tal qual descrito abaixo, em seu clone local.
3. Por fim, envie via email o projeto ou o fork/link do projeto para seu contato Bycoders_ com cópia para rh@bycoders.com.br.

# Descrição do projeto

Você recebeu um arquivo CNAB com os dados das movimentações finanaceira de várias lojas.
Precisamos criar uma maneira para que estes dados sejam importados para um banco de dados.

Sua tarefa é criar uma interface web que aceite upload do [arquivo CNAB](https://github.com/ByCodersTec/desafio-ruby-on-rails/blob/master/CNAB.txt), normalize os dados e armazene-os em um banco de dados relacional e exiba essas informações em tela.

**Sua aplicação web DEVE:**

1. Ter uma tela (via um formulário) para fazer o upload do arquivo(pontos extras se não usar um popular CSS Framework )
2. Interpretar ("parsear") o arquivo recebido, normalizar os dados, e salvar corretamente a informação em um banco de dados relacional, **se atente as documentações** que estão logo abaixo.
3. Exibir uma lista das operações importadas por lojas, e nesta lista deve conter um totalizador do saldo em conta
4. Ser escrita na sua linguagem de programação de preferência
5. Ser simples de configurar e rodar, funcionando em ambiente compatível com Unix (Linux ou Mac OS X). Ela deve utilizar apenas linguagens e bibliotecas livres ou gratuitas.
6. Git com commits atomicos e bem descritos
7. PostgreSQL, MySQL ou SQL Server
8. Ter testes automatizados
9. Docker compose (Pontos extras se utilizar)
10. Readme file descrevendo bem o projeto e seu setup
11. Incluir informação descrevendo como consumir o endpoint da API

**Sua aplicação web não precisa:**

1. Lidar com autenticação ou autorização (pontos extras se ela fizer, mais pontos extras se a autenticação for feita via OAuth).
2. Ser escrita usando algum framework específico (mas não há nada errado em usá-los também, use o que achar melhor).
3. Documentação da api.(Será um diferencial e pontos extras se fizer)

# Documentação do CNAB

| Descrição do campo  | Inicio | Fim | Tamanho | Comentário
| ------------- | ------------- | -----| ---- | ------
| Tipo  | 1  | 1 | 1 | Tipo da transação
| Data  | 2  | 9 | 8 | Data da ocorrência
| Valor | 10 | 19 | 10 | Valor da movimentação. *Obs.* O valor encontrado no arquivo precisa ser divido por cem(valor / 100.00) para normalizá-lo.
| CPF | 20 | 30 | 11 | CPF do beneficiário
| Cartão | 31 | 42 | 12 | Cartão utilizado na transação 
| Hora  | 43 | 48 | 6 | Hora da ocorrência atendendo ao fuso de UTC-3
| Dono da loja | 49 | 62 | 14 | Nome do representante da loja
| Nome loja | 63 | 81 | 19 | Nome da loja

# Documentação sobre os tipos das transações

| Tipo | Descrição | Natureza | Sinal |
| ---- | -------- | --------- | ----- |
| 1 | Débito | Entrada | + |
| 2 | Boleto | Saída | - |
| 3 | Financiamento | Saída | - |
| 4 | Crédito | Entrada | + |
| 5 | Recebimento Empréstimo | Entrada | + |
| 6 | Vendas | Entrada | + |
| 7 | Recebimento TED | Entrada | + |
| 8 | Recebimento DOC | Entrada | + |
| 9 | Aluguel | Saída | - |

# Avaliação

Seu projeto será avaliado de acordo com os seguintes critérios.

1. Sua aplicação preenche os requerimentos básicos?
2. Você documentou a maneira de configurar o ambiente e rodar sua aplicação?
3. Você seguiu as instruções de envio do desafio?
4. Qualidade e cobertura dos testes unitários.

Adicionalmente, tentaremos verificar a sua familiarização com as bibliotecas padrões (standard libs), bem como sua experiência com programação orientada a objetos a partir da estrutura de seu projeto.

# Referência

Este desafio foi baseado neste outro desafio: https://github.com/lschallenges/data-engineering

---

Boa sorte!
