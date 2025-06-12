# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'when validating' do
    it 'is invalid without a cart' do
      cart_item = build(:cart_item, cart: nil)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:cart]).to include('must exist')
    end

    it 'is invalid without a product' do
      cart_item = build(:cart_item, product: nil)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:product]).to include('must exist')
    end

    it 'is invalid with quantity less than or equal to 0' do
      cart_item = build(:cart_item, quantity: 0)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include('must be greater than 0')
    end
  end

  describe '#unit_price' do
    it 'returns the product price after validation' do
      product = create(:product, price: 15.0)
      cart_item = build(:cart_item, product: product)
      cart_item.valid?

      expect(cart_item.unit_price).to eq 15.0
    end
  end

  describe '#total_price' do
    it 'returns unit price multiplied by quantity after save' do
      product = create(:product, price: 20.0)
      cart_item = create(:cart_item, product: product, quantity: 2)

      expect(cart_item.total_price).to eq 40.0
    end
  end
end
