# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { 10.0 }

    trait :cheap do
      price { Faker::Commerce.price(range: 5.0..50.0) }
    end

    trait :expensive do
      price { Faker::Commerce.price(range: 100.0..999.0) }
    end
  end
end
