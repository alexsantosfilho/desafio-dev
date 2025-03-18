require 'rails_helper'

RSpec.describe CnabParserService, type: :service do
  let(:file_path) { Rails.root.join("spec", "fixtures", "files", "CNAB.txt") }

  describe "#call" do
    it "parses the file and returns an array of transactions" do
      service = described_class.new(file_path)
      transactions = service.call

      expect(transactions).to be_an(Array)
      expect(transactions.first).to include(
        transaction_type: 3,
        value: 142.0,
        store_name: "BAR DO JOÃO",
        store_owner: "JOÃO MACEDO"
      )
    end
  end
end
