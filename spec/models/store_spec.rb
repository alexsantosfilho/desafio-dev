require 'rails_helper'

RSpec.describe Store, type: :model do
  describe "associations" do
    before(:all) do
      # Criar um registro real no banco de dados de teste
      @store = Store.create!(name: "Loja Teste", owner: "Dono Teste")
    end

    it "has many transactions" do
      expect(@store).to respond_to(:transactions)
    end
  end
end
