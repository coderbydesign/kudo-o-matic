require 'rails_helper'
require 'jsonapi/resources/matchers'

RSpec.describe Api::V1::UserResource, type: :resource do
  let (:user) {create(:user)}
  subject {described_class.new(user, {})}

  it {is_expected.to have_primary_key :id}

  it {is_expected.to have_attribute :created_at}
  it {is_expected.to have_attribute :updated_at}
  it {is_expected.to have_attribute :name}
  it {is_expected.to have_attribute :email}
  it {is_expected.to have_attribute :avatar_url}
  it {is_expected.to have_attribute :admin}

  it {is_expected.to filter :created_at}
  it {is_expected.to filter :updated_at}
  it {is_expected.to filter :name}
  it {is_expected.to filter :email}
  it {is_expected.to filter :avatar_url}
  it {is_expected.to filter :admin}

  it {is_expected.to have_many :sent_transactions}
  it {is_expected.to have_many :received_transactions}
  it {is_expected.to have_many :votes}
end
