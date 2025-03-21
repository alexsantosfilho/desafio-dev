class TransactionsController < ApplicationController
  def index
    @stores = Store.order(:name)
  end

  def import
    file = params[:file]

    unless file
      redirect_to transactions_path, alert: "Por favor, selecione um arquivo." and return
    end

    result = Transactions::ImportService.new(file).call

    if result.success?
      redirect_to transactions_path, notice: "Arquivo importado com sucesso!"
    else
      redirect_to transactions_path, alert: result.error_message
    end
  end
end
