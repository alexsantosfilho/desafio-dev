module Transactions
  class ImportService
    def initialize(file)
      @file = file
    end

    def call
      transactions = CnabParserService.new(@file.path).call
      save_transactions(transactions)
      ServiceResult.success
    rescue StandardError => e
      Rails.logger.error("Erro ao importar arquivo: #{e.message}")
      ServiceResult.failure("Ocorreu um erro ao importar o arquivo. Verifique o formato e tente novamente.")
    end

    private

    def save_transactions(transactions)
      transactions.each do |transaction_data|
        store = StoreRepository.find_or_create_by_name_and_owner(transaction_data[:store_name], transaction_data[:store_owner])
        TransactionRepository.create_for_store(store, transaction_data)
        StoreBalanceUpdater.new(store).call
      end
    end
  end
end
