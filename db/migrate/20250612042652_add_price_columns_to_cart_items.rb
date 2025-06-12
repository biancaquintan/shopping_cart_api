# frozen_string_literal: true

class AddPriceColumnsToCartItems < ActiveRecord::Migration[7.1]
  def change
    add_column :cart_items, :unit_price, :decimal
    add_column :cart_items, :total_price, :decimal
  end
end
