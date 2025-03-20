# Desafio programação - para vaga desenvolvedor

Por favor leiam este documento do começo ao fim, com muita atenção.
O intuito deste teste é avaliar seus conhecimentos técnicos em programação.
O teste consiste em parsear [este arquivo de texto(CNAB)](https://github.com/ByCodersTec/desafio-ruby-on-rails/blob/master/CNAB.txt) e salvar suas informações(transações financeiras) em uma base de dados a critério do candidato.
Este desafio deve ser feito por você em sua casa. Gaste o tempo que você quiser, porém normalmente você não deve precisar de mais do que algumas horas.

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
- Ruby 3.4.2 ou superior
- Rails 7.0.0 ou superior
- PostgreSQL
- Docker (opcional)

### Passos para Configuração
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

# Overcommit no Rails

O **Overcommit** é uma ferramenta poderosa para automação de hooks de Git. Ela permite que você execute scripts e verificações antes de fazer commit, garantindo que o código siga padrões definidos e evitando a introdução de erros. No contexto do Ruby on Rails, o Overcommit pode ser configurado para rodar uma série de verificações úteis como:

- Verificação de estilo de código (usando `RuboCop`)
- Testes automatizados
- Análise de dependências
- Formatação do código (com `Prettier` ou `Standard`)

## Instalação do Overcommit

1. **Adicionar a gem** ao seu Gemfile:

```ruby
gem 'overcommit', require: false

2. Instalar a gem:

bundle install

3. Instalar o Overcommit:

overcommit --install


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
3. Crie o banco de dados:
   ```bash
    docker compose exec web rails db:create
   ```
4. Inicie a migração do banco de dados:
   ```bash
    docker compose exec web rails db:migrate
   ```
5. Crie o usuário:
   ```bash
    docker compose exec web rails db:seed
   ```
6. execute os testes:
   ```bash
    docker compose exec web bundle exec rspec
   ```
7. Acesse a aplicação em:
   ```
   http://localhost:3000
   ```

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
