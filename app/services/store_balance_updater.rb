class StoreBalanceUpdater
  def initialize(store)
    @store = store
  end

  def call
    balance = @store.transactions.sum { |t| t.transaction_type.in?([ 1, 4, 5, 6, 7, 8 ]) ? t.value : -t.value }
    @store.update(balance: balance)
  end
end
