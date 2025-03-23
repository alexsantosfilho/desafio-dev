class Transactions::ImportJob < ApplicationJob
  queue_as :default

  def perform(import_transaction_id, file_path)
    import_transaction = ImportTransaction.find(import_transaction_id)
    import_transaction.update!(status: :processing)

    begin
      Transactions::ImportService.new(file_path, import_transaction).call
      import_transaction.update!(status: :completed)
      message = "Importação concluída com sucesso!"
      type = :notice
    rescue StandardError => e
      import_transaction.update!(status: :failed, error_message: e.message)
      message = "Erro ao importar: #{e.message}"
      type = :alert
      Rails.logger.error("Erro ao importar arquivo: #{e.message}")
    ensure
      File.delete(file_path) if File.exist?(file_path)
    end

    stores = Store.includes(:transactions).all.order(:name)

    Turbo::StreamsChannel.broadcast_replace_to(
      "import_transactions",
      target: "transactions-table",
      partial: "api/v1/transactions/transactions_table",
      locals: { stores: stores }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "import_transactions",
      target: type,
      partial: "api/v1/transactions/import_status",
      locals: { message: message, type: type }
    )
  end
end
