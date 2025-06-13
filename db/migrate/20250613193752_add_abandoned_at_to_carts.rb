# frozen_string_literal: true

class AddAbandonedAtToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :abandoned_at, :datetime
  end
end
