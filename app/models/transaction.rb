class Transaction < ApplicationRecord
  belongs_to :store

  TRANSACTION_TYPES = {
    1 => "Débito",
    2 => "Boleto",
    3 => "Financiamento",
    4 => "Crédito",
    5 => "Recebimento Empréstimo",
    6 => "Vendas",
    7 => "Recebimento TED",
    8 => "Recebimento DOC",
    9 => "Aluguel"
  }.freeze

  def transaction_type_name
    TRANSACTION_TYPES[transaction_type] || "Desconhecido"
  end
end
