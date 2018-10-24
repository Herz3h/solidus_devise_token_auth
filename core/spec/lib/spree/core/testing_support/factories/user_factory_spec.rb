# frozen_string_literal: true

require 'rails_helper'
require 'spree/testing_support/factories/user_factory'

RSpec.describe 'user factory' do
  let(:factory_class) { Spree.user_class }

  describe 'user' do
    let(:factory) { :user }

    it_behaves_like 'a working factory'
  end

  describe 'admin user' do
    it "builds successfully" do
      expect(build(:user, :admin)).to be_a(factory_class)
    end

    it "creates successfully" do
      expect(build(:user, :admin)).to be_a(factory_class)
    end

    it "is creates a valid record" do
      expect(build(:user, :admin)).to be_valid
    end
  end

  describe 'user with addresses' do
    it "builds successfully" do
      expect(build(:user, :with_addresses)).to be_a(factory_class)
    end

    it "creates successfully" do
      expect(build(:user, :with_addresses)).to be_a(factory_class)
    end

    it "is creates a valid record" do
      expect(build(:user, :with_addresses)).to be_valid
    end
  end
end
