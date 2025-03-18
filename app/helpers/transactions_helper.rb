module TransactionsHelper
  TRANSACTION_TYPES = {
    1 => { description: "Débito", nature: "Entrada", sign: "+" },
    2 => { description: "Boleto", nature: "Saída", sign: "-" },
    3 => { description: "Financiamento", nature: "Saída", sign: "-" },
    4 => { description: "Crédito", nature: "Entrada", sign: "+" },
    5 => { description: "Recebimento Empréstimo", nature: "Entrada", sign: "+" },
    6 => { description: "Vendas", nature: "Entrada", sign: "+" },
    7 => { description: "Recebimento TED", nature: "Entrada", sign: "+" },
    8 => { description: "Recebimento DOC", nature: "Entrada", sign: "+" },
    9 => { description: "Aluguel", nature: "Saída", sign: "-" }
  }.freeze

  def transaction_sign(transaction_type)
    TRANSACTION_TYPES[transaction_type][:sign]
  end

  def transaction_nature(transaction_type)
    TRANSACTION_TYPES[transaction_type][:nature]
  end
end
