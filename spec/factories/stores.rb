# spec/factories/stores.rb
FactoryBot.define do
  factory :store do
    name { "Store Name" }
    owner { "Store Owner" }
    balance { 0.0 }
  end
end
