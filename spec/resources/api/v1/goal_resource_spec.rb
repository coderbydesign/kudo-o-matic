require 'rails_helper'
require 'jsonapi/resources/matchers'

RSpec.describe Api::V1::GoalResource, type: :resource do
  let (:goal) {create(:goal)}
  subject {described_class.new(goal, {})}

  it {is_expected.to have_primary_key :id}

  it {is_expected.to have_attribute :created_at}
  it {is_expected.to have_attribute :updated_at}
  it {is_expected.to have_attribute :name}
  it {is_expected.to have_attribute :amount}
  it {is_expected.to have_attribute :achieved_on}

  it {is_expected.to filter :created_at}
  it {is_expected.to filter :updated_at}
  it {is_expected.to filter :name}
  it {is_expected.to filter :amount}
  it {is_expected.to filter :achieved_on}

  it {is_expected.to have_one :balance}
end
