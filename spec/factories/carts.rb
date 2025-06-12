# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    total_price { 0.0 }

    trait :with_items do
      transient do
        items_count { 2 }
      end

      after(:create) do |cart, evaluator|
        create_list(:cart_item, evaluator.items_count, cart: cart)
        cart.recalculate_total_price
      end
    end
  end
end
