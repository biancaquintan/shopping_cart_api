# frozen_string_literal: true

# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  def create
    cart = current_cart
    cart.add_product(params[:product_id], params[:quantity])

    render json: CartSerializer.new(cart), status: :ok
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
end
