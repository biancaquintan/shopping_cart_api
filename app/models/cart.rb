# frozen_string_literal: true

# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product(product_id, quantity)
    item = cart_items.find_or_initialize_by(product_id: product_id)
    new_quantity = item.quantity.to_i + quantity.to_i
    item.update!(quantity: new_quantity)
    recalculate_total_price
    item
  end

  def recalculate_total_price
    update!(total_price: cart_items.sum(&:total_price))
  end
end
