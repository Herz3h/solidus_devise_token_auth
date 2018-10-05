# frozen_string_literal: true

module Spree
  class RoleUser < Spree::Base
    self.table_name = "spree_roles_users"
    belongs_to :role, class_name: "Spree::Role"
    belongs_to :user, class_name: Spree::UserClassHandle.new

    validates_uniqueness_of :role_id, scope: :user_id
  end
end
