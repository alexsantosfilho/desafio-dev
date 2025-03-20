# Documentação do Projeto

## Índice
1. Visão Geral
2. Estrutura do Projeto
3. Configuração do Ambiente
4. Endpoints da API
5. Exemplos de Uso
6. Testes
7. Docker
8. Considerações Finais

## Visão Geral
Este projeto é uma aplicação web desenvolvida em Ruby on Rails que permite o upload de arquivos CNAB (Controle Nacional de Automação Bancária) para processar transações financeiras de lojas. A aplicação faz o parse do arquivo, normaliza os dados e os armazena em um banco de dados PostgreSQL. Além disso, a aplicação exibe uma lista de transações por loja, incluindo o saldo total.

## Estrutura do Projeto
### Models
- **Store**: Representa uma loja e contém informações como nome e saldo.
  - **Atributos**: name, owner, balance.
  - **Relacionamento**: `has_many :transactions`.

- **Transaction**: Representa uma transação financeira.
  - **Atributos**: transaction_type, date, value, cpf, card, hour, store_id.
  - **Relacionamento**: `belongs_to :store`.

### Controllers
- **TransactionsController**:
  - `index`: Exibe a lista de transações por loja.
  - `import`: Processa o arquivo CNAB e salva as transações no banco de dados.

### Services
- **CnabParserService**: Faz o parse do arquivo CNAB e retorna uma lista de transações normalizadas.

### Views
- **transactions/index.html.erb**: Exibe a lista de transações por loja e o saldo total.

### Rotas
- `GET /`: Exibe a lista de transações.
- `POST /import`: Recebe o arquivo CNAB e processa as transações.

## Configuração do Ambiente
### Pré-requisitos
- Ruby 3.0.0 ou superior
- Rails 7.0.0 ou superior
- PostgreSQL
- Docker (opcional)

### Passos para Configuração
1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio
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
4. Inicie o servidor:
   ```bash
   rails server
   ```
A aplicação estará disponível em `http://localhost:3000`.

## Endpoints da API
### 1. Upload de Arquivo CNAB
- **Método**: `POST`
- **Endpoint**: `/import`
- **Descrição**: Recebe um arquivo CNAB e processa as transações.
- **Parâmetros**:
  - `file`: Arquivo CNAB no formato `.txt`.
- **Respostas**:
  - **Sucesso (200 OK)**:
    ```json
    {
      "message": "Arquivo importado com sucesso!"
    }
    ```
  - **Erro (400 Bad Request)**:
    ```json
    {
      "error": "Por favor, selecione um arquivo."
    }
    ```
  - **Erro (500 Internal Server Error)**:
    ```json
    {
      "error": "Ocorreu um erro ao importar o arquivo. Verifique o formato e tente novamente."
    }
    ```

### 2. Listar Transações por Loja
- **Método**: `GET`
- **Endpoint**: `/`
- **Descrição**: Exibe a lista de transações agrupadas por loja, incluindo o saldo total.
- **Resposta**:
  - **Sucesso (200 OK)**:
    ```html
    <h1>Transações por Loja</h1>
    <ul>
      <li>Loja A - Saldo: R$ 1000.00</li>
      <li>Loja B - Saldo: R$ -500.00</li>
    </ul>
    ```

## Exemplos de Uso
### Upload de Arquivo CNAB
Usando `curl`:
```bash
curl -X POST -F "file=@/caminho/para/seu/arquivo/CNAB.txt" http://localhost:3000/import
```

### Acessando a Lista de Transações
Abra o navegador e acesse:
```
http://localhost:3000
```

# Verificação de Segurança com Brakeman

O Brakeman foi utilizado para realizar uma análise estática de segurança no código do projeto. Abaixo estão os principais pontos verificados e os resultados obtidos:

## Resultados da Análise
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

## Como Executar o Brakeman
Para executar o Brakeman e verificar a segurança do código, é bem fácil:

execute no terminal do projeto o comando: brakeman

## Testes Automatizados
Para rodar os testes automatizados, execute:
```bash
bundle exec rspec
```

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
