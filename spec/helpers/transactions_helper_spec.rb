require 'rails_helper'

RSpec.describe TransactionsHelper, type: :helper do
  describe "#transaction_sign" do
    it "returns the correct sign for a transaction type" do
      expect(helper.transaction_sign(1)).to eq("+")
      expect(helper.transaction_sign(2)).to eq("-")
    end
  end

  describe "#transaction_nature" do
    it "returns the correct nature for a transaction type" do
      expect(helper.transaction_nature(1)).to eq("Entrada")
      expect(helper.transaction_nature(2)).to eq("Saída")
    end
  end
end
