# frozen_string_literal: true

class RenameApiKeyToSpreeApiKey < ActiveRecord::Migration[4.2]
  def change
    unless defined?(User)
      if column_exists?(:spree_users, :api_key)
        rename_column :spree_users, :api_key, :spree_api_key
      end
    end
  end
end
