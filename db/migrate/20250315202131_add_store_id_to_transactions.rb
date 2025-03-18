class AddStoreIdToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions, :store, foreign_key: true
  end
end
