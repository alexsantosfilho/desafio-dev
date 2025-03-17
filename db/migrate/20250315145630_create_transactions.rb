class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.integer :type
      t.date :date
      t.decimal :value
      t.string :cpf
      t.string :card
      t.time :hour
      t.string :store_owner
      t.string :store_name

      t.timestamps
    end
  end
end
