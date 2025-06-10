# frozen_string_literal: true

# app/models/cart_item.rb
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }

  def unit_price
    product.price
  end

  def total_price
    unit_price * quantity
  end
end
