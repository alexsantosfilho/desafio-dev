# Use a imagem oficial do Ruby
FROM ruby:3.4.2

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Crie um diretório para o aplicativo
RUN mkdir /desafio-dev
WORKDIR /desafio-dev

# Copie o Gemfile e o Gemfile.lock para o contêiner
COPY Gemfile /desafio-dev/Gemfile
COPY Gemfile.lock /desafio-dev/Gemfile.lock

# Instale as gems
RUN bundle install

# Copie o restante do código do aplicativo para o contêiner
COPY . /desafio-dev

# Exponha a porta 3000
EXPOSE 3000

# Comando para rodar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]