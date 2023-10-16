FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Quote.yoda }
    unit_price { Faker::Commerce.price }
    merchant { association :merchant }

  end
end