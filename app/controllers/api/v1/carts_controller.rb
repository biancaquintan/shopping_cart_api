# frozen_string_literal: true

# app/controllers/api/v1/carts_controller.rb
module Api
  module V1
    class CartsController < ApplicationController
      def create
        cart = current_cart
        product_id = cart_params[:product_id]
        quantity = cart_params[:quantity].to_i
        quantity = 1 if quantity <= 0

        cart.add_product(product_id, quantity)

        render json: Api::V1::CartSerializer.new(cart), status: :ok
      end

      private

      def current_cart
        Cart.find_by(id: session[:cart_id]) || create_cart
      end

      def create_cart
        cart = Cart.create!
        session[:cart_id] = cart.id
        cart
      end

      def cart_params
        params.permit(:product_id, :quantity)
      end
    end
  end
end
