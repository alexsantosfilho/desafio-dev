FactoryBot.define do
  factory :transaction do
    transaction_type { 1 } # Valor padrão para transaction_type
    date { Date.today }
    value { 100.0 }
    cpf { "12345678901" }
    card { "1234****5678" }
    hour { Time.now }
    store # Associa automaticamente a uma Store
  end
end
