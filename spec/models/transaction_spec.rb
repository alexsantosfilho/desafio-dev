require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:store) }
  end

  describe "#transaction_type_name" do
    it "returns the correct transaction type name" do
      transaction = build(:transaction, transaction_type: 1)
      expect(transaction.transaction_type_name).to eq("Débito")
    end

    it "returns 'Desconhecido' for an invalid transaction type" do
      transaction = build(:transaction, transaction_type: 99)
      expect(transaction.transaction_type_name).to eq("Desconhecido")
    end
  end
end
