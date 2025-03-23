class Api::V1::CnabController < ApplicationController
  def import
    file = params[:file]

    CnabImporter.new(file).call
    redirect_to api_v1_transactions_path, notice: "Arquivo enviado com sucesso! Aguarde o processamento."
  rescue => e
    redirect_to api_v1_transactions_path, alert: e.message
  end
end
