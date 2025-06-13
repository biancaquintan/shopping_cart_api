# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe '#perform' do
    let!(:active_cart) { create(:cart, updated_at: 2.hours.ago, abandoned_at: nil) }
    let!(:inactive_cart) { create(:cart, updated_at: 4.hours.ago, abandoned_at: nil) }
    let!(:recent_abandoned_cart) { create(:cart, updated_at: 6.days.ago, abandoned_at: 6.days.ago) }
    let!(:old_abandoned_cart) { create(:cart, updated_at: 8.days.ago, abandoned_at: 8.days.ago) }

    it 'marks carts with more than 3 hours of inactivity as abandoned' do
      expect do
        described_class.new.perform
      end.to change { inactive_cart.reload.abandoned_at }.from(nil)
    end

    it 'does not mark carts with less than 3 hours of inactivity as abandoned' do
      described_class.new.perform
      expect(active_cart.reload.abandoned_at).to be_nil
    end

    it 'removes carts abandoned for more than 7 days' do
      expect do
        described_class.new.perform
      end.to change { Cart.exists?(old_abandoned_cart.id) }.from(true).to(false)
    end

    it 'does not remove carts abandoned for less than 7 days' do
      described_class.new.perform
      expect(Cart.exists?(recent_abandoned_cart.id)).to be true
    end
  end
end
