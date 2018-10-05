class RemoveApiKeyFromSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    if column_exists?(Spree.user_class.table_name.to_sym, :api_key)
      remove_column Spree.user_class.table_name.to_sym, :api_key, :string, limit: 40
    end
  end
end
