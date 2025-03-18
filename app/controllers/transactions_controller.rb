class TransactionsController < ApplicationController
  def index
    @stores = Store.order(:name)
  end

  def import
    file = params[:file]

    unless file
      redirect_to transactions_path, alert: "Por favor, selecione um arquivo." and return
    end

    begin
      transactions = CnabParserService.new(file.path).call

      save_transactions(transactions)
      redirect_to transactions_path, notice: "Arquivo importado com sucesso!"
    rescue StandardError => e
      Rails.logger.error("Erro ao importar arquivo: #{e.message}")
      redirect_to transactions_path, alert: "Ocorreu um erro ao importar o arquivo. Verifique o formato e tente novamente."
    end
  end

  private

  def save_transactions(transactions)
    transactions.each do |transaction_data|
      store = Store.find_or_create_by(name: transaction_data[:store_name], owner: transaction_data[:store_owner])
      store.transactions.create(transaction_data)
      update_store_balance(store)
    end
  end

  def update_store_balance(store)
    balance = store.transactions.sum { |t| t.transaction_type.in?([ 1, 4, 5, 6, 7, 8 ]) ? t.value : -t.value }
    store.update(balance: balance)
  end
end
