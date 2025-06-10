# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    subject(:product) { build(:product, **overrides) }

    context 'when name is missing' do
      let(:overrides) { { name: nil } }

      it 'is invalid with error on name' do
        expect(product).not_to be_valid
        expect(product.errors[:name]).to include("can't be blank")
      end
    end

    context 'when price is missing' do
      let(:overrides) { { price: nil } }

      it 'is invalid with error on price' do
        expect(product).not_to be_valid
        expect(product.errors[:price]).to include("can't be blank")
      end
    end

    context 'when price is negative' do
      let(:overrides) { { price: -1 } }

      it 'is invalid with numericality error on price' do
        expect(product).not_to be_valid
        expect(product.errors[:price]).to include('must be greater than or equal to 0')
      end
    end

    context 'when all attributes are valid' do
      let(:overrides) { {} }

      it 'is valid' do
        expect(product).to be_valid
      end
    end
  end
end
