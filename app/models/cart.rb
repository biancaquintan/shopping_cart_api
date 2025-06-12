# frozen_string_literal: true

# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  after_initialize do
    self.total_price ||= 0
  end

  def add_product(product_id, quantity)
    product = Product.find_by(id: product_id)
    return unless product

    item = find_or_initialize_item(product)
    update_item_quantity(item, quantity)
    item
  end

  def recalculate_total_price
    total = cart_items.includes(:product).sum(&:total_price)
    update!(total_price: total)
  end

  private

  def find_or_initialize_item(product)
    cart_items.find_or_initialize_by(product: product)
  end

  def update_item_quantity(item, quantity)
    new_quantity = item.quantity.to_i + quantity.to_i
    return item.destroy if new_quantity < 1

    item.update!(quantity: new_quantity)
  end
end
