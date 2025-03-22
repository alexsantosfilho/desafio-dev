class Transactions::ImportJob < ApplicationJob
  queue_as :default

  def perform(import_transaction_id, file_path)
    import_transaction = ImportTransaction.find(import_transaction_id)
    import_transaction.update!(status: :processing)

    begin
      Transactions::ImportService.new(file_path, import_transaction).call
      import_transaction.update!(status: :completed)
    rescue StandardError => e
      import_transaction.update!(status: :failed, error_message: e.message)
      Rails.logger.error("Erro ao importar arquivo: #{e.message}")
    ensure
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
