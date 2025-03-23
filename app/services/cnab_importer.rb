class CnabImporter
  def initialize(file)
    @file = file
  end

  def call
    validate_file!
    temp_file_path = save_temp_file
    import_transaction = create_import_transaction
    enqueue_import_job(import_transaction, temp_file_path)
    import_transaction
  rescue => e
    raise e
  end

  private

  def validate_file!
    raise "Por favor, selecione um arquivo." unless @file
    raise "Por favor, selecione um arquivo .txt válido." unless @file.original_filename.end_with?(".txt")
  end

  def save_temp_file
    temp_file_path = Rails.root.join("tmp", @file.original_filename)
    File.open(temp_file_path, "wb") { |f| f.write(@file.read) }
    temp_file_path
  rescue => e
    raise "Erro ao salvar o arquivo: #{e.message}"
  end

  def create_import_transaction
    ImportTransaction.create!(file_name: @file.original_filename, status: :pending)
  rescue => e
    raise "Erro ao criar transação de importação: #{e.message}"
  end

  def enqueue_import_job(import_transaction, temp_file_path)
    Transactions::ImportJob.perform_later(import_transaction.id, temp_file_path.to_s)
  rescue => e
    raise "Erro ao enfileirar o trabalho de importação: #{e.message}"
  end
end
