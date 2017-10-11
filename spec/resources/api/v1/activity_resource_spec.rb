require 'rails_helper'
require 'jsonapi/resources/matchers'

RSpec.describe Api::V1::ActivityResource, type: :resource do
  let (:activity) {create(:activity)}
  subject {described_class.new(activity, {})}

  it {is_expected.to have_primary_key :id}

  it {is_expected.to have_attribute :created_at}
  it {is_expected.to have_attribute :updated_at}
  it {is_expected.to have_attribute :name}
  it {is_expected.to have_attribute :suggested_amount}

  it {is_expected.to filter :created_at}
  it {is_expected.to filter :updated_at}
  it {is_expected.to filter :name}
  it {is_expected.to filter :suggested_amount}

  it {is_expected.to have_many :transactions}
end
