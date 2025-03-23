require 'rails_helper'

RSpec.describe StoreBalanceUpdater do
  let(:store) { create(:store) }
  let(:service) { described_class.new(store) }

  describe '#call' do
    before do
      create(:transaction, store: store, transaction_type: 1, value: 100.0)
      create(:transaction, store: store, transaction_type: 2, value: 50.0)
    end

    it 'updates the store balance' do
      service.call
      expect(store.reload.balance).to eq(50.0)
    end
  end
end
