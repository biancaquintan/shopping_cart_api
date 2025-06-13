# frozen_string_literal: true

# app/controllers/api/v1/carts_controller.rb
module Api
  module V1
    class CartsController < ApplicationController
      def create
        ensure_cart_and_add_item
      end

      def add_item
        ensure_cart_and_add_item
      end

      def show
        render json: Api::V1::CartSerializer.new(current_cart), status: :ok
      end

      private

      def ensure_cart_and_add_item
        product = Product.find_by!(id: cart_params[:product_id])
        quantity = normalized_quantity(cart_params[:quantity])

        current_cart.add_product(product.id, quantity)
        current_cart.recalculate_total_price

        render json: Api::V1::CartSerializer.new(current_cart), status: :ok
      rescue ActiveRecord::RecordNotFound => e
        handle_not_found(e)
      rescue ActiveRecord::RecordInvalid => e
        handle_invalid_record(e)
      end

      def handle_not_found(error)
        render json: { error: error.message }, status: :not_found
      end

      def handle_invalid_record(error)
        render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
      end

      def current_cart
        return @current_cart if defined?(@current_cart)

        @current_cart = (Cart.find_by(id: session[:cart_id]) if session[:cart_id])

        unless @current_cart
          @current_cart = Cart.create!(total_price: 0.0)
          session[:cart_id] = @current_cart.id
        end

        @current_cart
      end

      def cart_params
        params.except(:cart).permit(:product_id, :quantity)
      end

      def normalized_quantity(quantity)
        [quantity.to_i, 1].max
      end
    end
  end
end
