# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:cart_items) }
  end

  describe '#add_product' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, price: 10.0) }

    context 'when the product is not yet in the cart' do
      it 'adds a new cart_item with the given quantity' do
        expect do
          cart.add_product(product.id, 2)
        end.to change { cart.cart_items.count }.by(1)

        item = cart.cart_items.find_by(product_id: product.id)
        expect(item.quantity).to eq(2)
      end
    end

    context 'when the product already exists in the cart' do
      before { create(:cart_item, cart: cart, product: product, quantity: 1) }

      it 'increments the quantity of the existing cart_item' do
        cart.add_product(product.id, 3)
        item = cart.cart_items.find_by(product_id: product.id)
        expect(item.quantity).to eq(4)
      end
    end
  end

  describe '#recalculate_total_price' do
    let(:cart) { create(:cart) }
    let(:product1) { create(:product, price: 5.0) }
    let(:product2) { create(:product, price: 8.0) }

    before do
      create(:cart_item, cart: cart, product: product1, quantity: 2) # 10
      create(:cart_item, cart: cart, product: product2, quantity: 1) # 8
    end

    it 'updates total_price with the sum of cart_items' do
      cart.recalculate_total_price
      expect(cart.total_price).to eq(18.0)
    end
  end
  # describe 'mark_as_abandoned' do
  #   let(:shopping_cart) { create(:shopping_cart) }

  #   it 'marks the shopping cart as abandoned if inactive for a certain time' do
  #     shopping_cart.update(last_interaction_at: 3.hours.ago)
  #     expect { shopping_cart.mark_as_abandoned }.to change { shopping_cart.abandoned? }.from(false).to(true)
  #   end
  # end

  # describe 'remove_if_abandoned' do
  #   let(:shopping_cart) { create(:shopping_cart, last_interaction_at: 7.days.ago) }

  #   it 'removes the shopping cart if abandoned for a certain time' do
  #     shopping_cart.mark_as_abandoned
  #     expect { shopping_cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
  #   end
  # end
end
