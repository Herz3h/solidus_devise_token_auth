# frozen_string_literal: true

class AddIndexToUserSpreeApiKey < ActiveRecord::Migration[4.2]
  def change
    unless defined?(User)
      if column_exists?(:spree_users, :spree_api_key)
        add_index :spree_users, :spree_api_key
      end
    end
  end
end
