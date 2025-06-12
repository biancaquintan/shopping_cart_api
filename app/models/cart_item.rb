# frozen_string_literal: true

# app/models/cart_item.rb
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_unit_price, on: :create
  before_save :set_total_price

  after_save :update_cart_total
  after_destroy :update_cart_total

  def total_price
    self[:total_price]
  end

  private

  def set_unit_price
    self.unit_price ||= product&.price
  end

  def set_total_price
    self.total_price = unit_price.to_f * quantity.to_i
  end

  def update_cart_total
    cart&.recalculate_total_price
  end
end
