require 'rails_helper'
require 'jsonapi/resources/matchers'

RSpec.describe Api::V1::TransactionResource, type: :resource do
  let (:transaction) {create(:transaction)}
  subject {described_class.new(transaction, {})}

  it {is_expected.to have_primary_key :id}

  it {is_expected.to have_attribute :created_at}
  it {is_expected.to have_attribute :updated_at}
  it {is_expected.to have_attribute :amount}
  it {is_expected.to have_attribute :image_file_name}
  it {is_expected.to have_attribute :image_content_type}
  it {is_expected.to have_attribute :image_file_size}
  it {is_expected.to have_attribute :image_updated_at}

  it {is_expected.to filter :amount}
  it {is_expected.to filter :image_url_original}
  it {is_expected.to filter :image_url_thumb}
  it {is_expected.to filter :image_file_name}
  it {is_expected.to filter :image_content_type}
  it {is_expected.to filter :image_file_size}
  it {is_expected.to filter :image_updated_at}
  it {is_expected.to filter :created_at}
  it {is_expected.to filter :updated_at}

  it {is_expected.to have_one :balance}
  it {is_expected.to have_one :activity}
  it {is_expected.to have_many :votes}
end
