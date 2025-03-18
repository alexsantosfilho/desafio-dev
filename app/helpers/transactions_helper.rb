module TransactionsHelper
  TRANSACTION_TYPES = {
    debit: { description: "Débito", nature: "Entrada", sign: "+" },
    boleto: { description: "Boleto", nature: "Saída", sign: "-" },
    financing: { description: "Financiamento", nature: "Saída", sign: "-" },
    credit: { description: "Crédito", nature: "Entrada", sign: "+" },
    loan_receipt: { description: "Recebimento Empréstimo", nature: "Entrada", sign: "+" },
    sales: { description: "Vendas", nature: "Entrada", sign: "+" },
    ted_receipt: { description: "Recebimento TED", nature: "Entrada", sign: "+" },
    doc_receipt: { description: "Recebimento DOC", nature: "Entrada", sign: "+" },
    rent: { description: "Aluguel", nature: "Saída", sign: "-" }
  }.freeze

  def transaction_sign(transaction_type)
    TRANSACTION_TYPES[transaction_type][:sign]
  end

  def transaction_nature(transaction_type)
    TRANSACTION_TYPES[transaction_type][:nature]
  end
end
