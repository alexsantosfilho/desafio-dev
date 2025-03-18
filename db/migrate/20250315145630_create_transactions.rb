class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type
      t.date :date
      t.decimal :value
      t.string :cpf
      t.string :card
      t.time :hour
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
