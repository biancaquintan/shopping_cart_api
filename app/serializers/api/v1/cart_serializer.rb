# frozen_string_literal: true

# app/serializers/api/v1/cart_serializer.rb
module Api
  module V1
    class CartSerializer
      def initialize(cart)
        @cart = cart
      end

      def as_json(*)
        {
          id: @cart.id,
          products: serialized_products,
          total_price: @cart.total_price
        }
      end

      private

      def serialized_products
        @cart.cart_items.includes(:product).map do |item|
          {
            id: item.product.id,
            name: item.product.name,
            quantity: item.quantity,
            unit_price: item.unit_price,
            total_price: item.total_price
          }
        end
      end
    end
  end
end
