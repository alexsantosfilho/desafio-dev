require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  before(:each) do
    @user = User.create!(email_address: "bycoders_@email.com", password: "senha1234")
    @session = @user.sessions.create!(user_agent: "RSpec Test", ip_address: "127.0.0.1")

    cookies.signed[:session_id] = @session.id

    Store.delete_all
  end

  describe "GET #index" do
    it "assigns all stores ordered by name to @stores" do
      store1 = create(:store, name: "Store B")
      store2 = create(:store, name: "Store A")

      get :index

      expect(assigns(:stores)).to eq([ store2, store1 ])
    end
  end
end
