class AddDefaultUser < ActiveRecord::Migration[8.0]
  def up
    User.create!(email_address: "bycoders_@email.com", password: "senha1234")
  end
end
