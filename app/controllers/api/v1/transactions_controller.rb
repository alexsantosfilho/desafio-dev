module Api
  module V1
    class TransactionsController < ApplicationController
      def index
        @stores = Store.order(:name)
        @import_transaction = ImportTransaction.last
      end
    end
  end
end
