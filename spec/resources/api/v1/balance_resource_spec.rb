require 'rails_helper'
require 'jsonapi/resources/matchers'

RSpec.describe Api::V1::BalanceResource, type: :resource do
  let (:balance) {create(:balance)}
  subject {described_class.new(balance, {})}

  it {is_expected.to have_primary_key :id}

  it {is_expected.to have_attribute :current}
  it {is_expected.to have_attribute :name}
end
