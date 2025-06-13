# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/carts', type: :request do
  describe 'POST /api/v1/carts' do
    let!(:product) { create(:product, price: 10.0) }

    context 'when the cart doesnt yet exist in the session' do
      it 'creates cart and adds product' do
        post '/api/v1/carts', params: { product_id: product.id, quantity: 2 }, as: :json

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['products'].size).to eq(1)
        expect(json['products'][0]['id']).to eq(product.id)
        expect(json['products'][0]['quantity']).to eq(2)
        expect(json['total_price'].to_f).to eq(20.0)
      end
    end

    context 'when the product already exists in the cart' do
      let!(:cart) { Cart.create!.tap { |c| c.add_product(product.id, 1) } }

      before do
        inject_cart_into_controller(cart)
      end

      it 'increases the quantity of the existing product' do
        expect do
          post '/api/v1/carts',
               params: { product_id: product.id, quantity: 2 },
               as: :json
        end.to change {
          cart.reload.cart_items.find_by(product_id: product.id).quantity
        }.from(1).to(3)

        json = JSON.parse(response.body)
        expect(json['total_price'].to_f).to be_within(0.01).of(30.0)
      end
    end
  end

  describe 'GET /api/v1/carts' do
    let!(:cart) { create(:cart, :with_items, items_count: 2) }

    before do
      inject_cart_into_controller(cart)
    end

    it 'returns cart with all products and correct total price' do
      get '/api/v1/carts', as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['id']).to eq(cart.id)
      expect(json['products'].size).to eq(2)

      json['products'].each do |product|
        expect(product).to include('id', 'name', 'quantity', 'unit_price', 'total_price')
      end

      expected_total = cart.cart_items.sum(&:total_price)
      expect(json['total_price'].to_f).to eq(expected_total.to_f)
    end
  end

  describe 'POST /add_items' do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: 'Test Product', price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    before do
      inject_cart_into_controller(cart)
    end

    context 'when the product already is in the cart' do
      subject do
        post '/api/v1/carts/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/api/v1/carts/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end

    context 'when the product is not yet in the cart' do
      let(:new_product) { create(:product, :cheap) }

      it 'adds the new product to the cart' do
        expect do
          post '/api/v1/carts/add_item', params: { product_id: new_product.id, quantity: 1 }, as: :json
        end.to change { cart.reload.cart_items.count }.by(1)

        json = JSON.parse(response.body)
        expect(json['products'].any? { |p| p['id'] == new_product.id }).to be true
      end
    end

    context 'when the product doesnt exist' do
      it 'returns not found error' do
        post '/api/v1/carts/add_item', params: { product_id: -1, quantity: 1 }, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end
  end

  describe 'DELETE /api/v1/carts/:product_id' do
    let(:product) { create(:product, price: 15.0) }
    let(:other_product) { create(:product, price: 20.0) }
    let!(:cart) { Cart.create!.tap { |c| c.add_product(product.id, 2) } }

    before do
      inject_cart_into_controller(cart)
    end

    context 'when the product is in the cart' do
      it 'removes the product and updates total price' do
        expect do
          delete "/api/v1/carts/#{product.id}", as: :json
        end.to change { cart.reload.cart_items.count }.by(-1)

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['products']).to be_empty
        expect(json['total_price'].to_f).to eq(0.0)
      end
    end

    context 'when the product is not in the cart' do
      it 'returns not found error' do
        delete "/api/v1/carts/#{other_product.id}", as: :json

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json['error']).to match(/Product not found in cart/)
      end
    end

    context 'when the product doesnt exist at all' do
      it 'returns not found error' do
        delete '/api/v1/carts/999999', as: :json

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json['error']).to match(/Couldn't find Product/)
      end
    end
  end
end
