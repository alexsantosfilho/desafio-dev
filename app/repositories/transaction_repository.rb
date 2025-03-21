class TransactionRepository
  def self.create_for_store(store, transaction_data)
    store.transactions.create(transaction_data)
  end
end
