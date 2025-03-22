class CreateImportTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :import_transactions do |t|
      t.string :file_name, null: false
      t.integer :status, default: 0, null: false
      t.text :error_message

      t.timestamps
    end
  end
end
