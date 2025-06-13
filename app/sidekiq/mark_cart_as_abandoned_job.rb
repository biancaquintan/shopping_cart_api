# frozen_string_literal: true

class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*_args)
    mark_carts_as_abandoned
    delete_old_abandoned_carts
  end

  private

  def mark_carts_as_abandoned
    Cart.where(abandoned_at: nil)
        .where('updated_at <= ?', 3.hours.ago)
        .find_each do |cart|
          cart.update!(abandoned_at: Time.current)
        end
  end

  def delete_old_abandoned_carts
    Cart.where('abandoned_at <= ?', 7.days.ago)
        .find_each(&:destroy!)
  end
end
