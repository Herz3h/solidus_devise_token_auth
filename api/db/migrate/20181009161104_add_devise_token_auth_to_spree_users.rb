class AddDeviseTokenAuthToSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    unless column_exists?(Spree.user_class.table_name.to_sym, :provider)
      add_column Spree.user_class.table_name.to_sym, :provider, :string, null: false, default: 'email'
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :uid)
      add_column Spree.user_class.table_name.to_sym, :uid, :string, null: false, default: ''
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :encrypted_password)
      add_column Spree.user_class.table_name.to_sym, :encrypted_password, :string, null: false, default: ''
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :reset_password_token)
      add_column Spree.user_class.table_name.to_sym, :reset_password_token, :string
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :reset_password_sent_at)
      add_column Spree.user_class.table_name.to_sym, :reset_password_sent_at, :datetime
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :allow_password_change)
      add_column Spree.user_class.table_name.to_sym, :allow_password_change, :boolean, default: false
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :remember_created_at)
      add_column Spree.user_class.table_name.to_sym, :remember_created_at, :datetime
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :sign_in_count)
      add_column Spree.user_class.table_name.to_sym, :sign_in_count, :integer, null: false, default: 0
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :current_sign_in_at)
      add_column Spree.user_class.table_name.to_sym, :current_sign_in_at, :datetime
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :last_sign_in_at)
      add_column Spree.user_class.table_name.to_sym, :last_sign_in_at, :datetime
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :current_sign_in_ip)
      add_column Spree.user_class.table_name.to_sym, :current_sign_in_ip, :string
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :last_sign_in_ip)
      add_column Spree.user_class.table_name.to_sym, :last_sign_in_ip, :string
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :email)
      add_column Spree.user_class.table_name.to_sym, :email, :string, null: false
    end

    unless column_exists?(Spree.user_class.table_name.to_sym, :tokens)
      add_column Spree.user_class.table_name.to_sym, :tokens, :text
    end

    if column_exists?(Spree.user_class.table_name.to_sym, :email)
      add_index Spree.user_class.table_name.to_sym, :email, unique: true
    end

    if column_exists?(Spree.user_class.table_name.to_sym, :uid) && column_exists?(Spree.user_class.table_name.to_sym, :provider)
      add_index Spree.user_class.table_name.to_sym, %i(uid provider), unique: true
    end

    if column_exists?(Spree.user_class.table_name.to_sym, :reset_password_token)
      add_index Spree.user_class.table_name.to_sym, :reset_password_token, unique: true
    end
  end
end
