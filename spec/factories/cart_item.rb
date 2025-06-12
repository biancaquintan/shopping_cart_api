# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    cart
    product
    quantity { rand(1..5) }

    after(:create) do |item|
      item.cart.recalculate_total_price
    end
  end
end
