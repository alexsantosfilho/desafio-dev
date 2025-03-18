class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :owner
      t.decimal :balance, default: 0.0

      t.timestamps
    end
  end
end
