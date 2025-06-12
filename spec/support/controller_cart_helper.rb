# frozen_string_literal: true

# spec/support/controller_cart_helper.rb
module ControllerCartHelper
  def inject_cart_into_controller(cart)
    allow_any_instance_of(Api::V1::CartsController)
      .to receive(:current_cart)
      .and_return(cart)
  end
end
