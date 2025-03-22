module Transactions
  class ImportService
    def initialize(file_path, import_transaction)
      @file_path = file_path
      @import_transaction = import_transaction
    end

    def call
      transactions = CnabParserService.new(@file_path).call
      save_transactions(transactions)
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
