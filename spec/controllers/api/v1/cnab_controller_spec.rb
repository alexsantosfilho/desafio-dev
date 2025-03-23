require 'rails_helper'

RSpec.describe Api::V1::CnabController, type: :controller do
  before(:each) do
    @user = User.create!(email_address: "bycoders_@email.com", password: "senha1234")
    @session = @user.sessions.create!(user_agent: "RSpec Test", ip_address: "127.0.0.1")

    cookies.signed[:session_id] = @session.id

    Store.delete_all
  end

  describe 'POST #import' do
    context 'when no file is provided' do
      it 'redirects with an alert' do
        post :import
        expect(response).to redirect_to(api_v1_transactions_path)
        expect(flash[:alert]).to eq('Por favor, selecione um arquivo.')
      end
    end

    context 'when a file is provided' do
      let(:file) { fixture_file_upload('spec/fixtures/files/CNAB.txt', 'text/plain') }

      it 'creates an ImportTransaction and enqueues a job' do
        expect {
          post :import, params: { file: file }
        }.to change(ImportTransaction, :count).by(1)

        expect(response.status).to eq(204)
        expect(ImportTransaction.last.status).to eq('pending')
      end
    end
  end
end
