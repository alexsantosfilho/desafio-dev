module Api
  module V1
    class TransactionsController < ApplicationController
      def index
        @stores = Store.order(:name)
        @import_transaction = ImportTransaction.last
      end

      def import
        file = params[:file]

        unless file
          redirect_to api_v1_transactions_path, alert: "Por favor, selecione um arquivo." and return
        end

        temp_file_path = Rails.root.join("tmp", file.original_filename)
        File.open(temp_file_path, "wb") { |f| f.write(file.read) }

        import_transaction = ImportTransaction.create!(file_name: file.original_filename, status: :pending)

        Transactions::ImportJob.perform_later(import_transaction.id, temp_file_path.to_s)

        render json: {}, status: :no_content
      end
    end
  end
end
