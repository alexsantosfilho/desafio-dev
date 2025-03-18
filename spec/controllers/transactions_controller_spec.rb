require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  before(:each) do
    Store.delete_all
  end

  let(:valid_file) { fixture_file_upload('CNAB.txt', 'text/plain') }
  let(:invalid_file) { fixture_file_upload('invalid_cnab.txt', 'text/plain') }

  describe "GET #index" do
    it "assigns all stores ordered by name to @stores" do
      store1 = create(:store, name: "Store B")
      store2 = create(:store, name: "Store A")

      get :index

      expect(assigns(:stores)).to eq([ store2, store1 ])
    end
  end

  describe "POST #import" do
    context "when no file is uploaded" do
      it "redirects with an alert" do
        post :import

        expect(response).to redirect_to(transactions_path)
        expect(flash[:alert]).to eq("Por favor, selecione um arquivo.")
      end
    end

    context "when a valid file is uploaded" do
      it "imports transactions and redirects with a notice" do
        allow(CnabParserService).to receive_message_chain(:new, :call).and_return([ { transaction_type: 1, value: 100.0, store_name: "Store A", store_owner: "Owner A" } ])

        post :import, params: { file: valid_file }

        expect(response).to redirect_to(transactions_path)
        expect(flash[:notice]).to eq("Arquivo importado com sucesso!")
      end
    end

    context "when an error occurs during import" do
      it "redirects with an alert" do
        allow(CnabParserService).to receive_message_chain(:new, :call).and_raise(StandardError.new("Error"))

        post :import, params: { file: invalid_file }

        expect(response).to redirect_to(transactions_path)
        expect(flash[:alert]).to eq("Ocorreu um erro ao importar o arquivo. Verifique o formato e tente novamente.")
      end
    end
  end

  describe "private methods" do
    describe "#save_transactions" do
      it "creates stores and transactions" do
        transactions_data = [ { transaction_type: 1, value: 100.0, store_name: "Store A", store_owner: "Owner A" } ]
        controller.instance_variable_set(:@controller, controller)

        expect { controller.send(:save_transactions, transactions_data) }.to change(Store, :count).by(1).and change(Transaction, :count).by(1)
      end
    end

    describe "#update_store_balance" do
      it "updates the store balance correctly" do
        store = create(:store)
        create(:transaction, store: store, transaction_type: 1, value: 100.0)
        create(:transaction, store: store, transaction_type: 2, value: 50.0)

        controller.send(:update_store_balance, store)

        expect(store.reload.balance).to eq(50.0)
      end
    end
  end
end
