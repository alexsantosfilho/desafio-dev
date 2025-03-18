class Transaction < ApplicationRecord
  belongs_to :store

  TRANSACTION_TYPES = {
    debit: "Débito",
    boleto: "Boleto",
    financing: "Financiamento",
    credit: "Crédito",
    loan_receipt: "Recebimento Empréstimo",
    sales: "Vendas",
    ted_receipt: "Recebimento TED",
    doc_receipt: "Recebimento DOC",
    rent: "Aluguel"
  }.freeze

  def transaction_type_name
    TRANSACTION_TYPES[transaction_type] || "Desconhecido"
  end
end
