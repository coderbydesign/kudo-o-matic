require 'rails_helper'
require 'jsonapi/resources/matchers'

RSpec.describe Api::V1::TransactionResource, type: :resource do
  let (:transaction) {create(:transaction)}
  let (:user) {create(:user)}
  subject {described_class.new(transaction, {api_user: user})}

  it {is_expected.to have_primary_key :id}

  it {is_expected.to have_attribute :created_at}
  it {is_expected.to have_attribute :updated_at}
  it {is_expected.to have_attribute :amount}
  it {is_expected.to have_attribute :activity}
  it {is_expected.to have_attribute :votes_count}
  it {is_expected.to have_attribute :api_user_voted}
  it {is_expected.to have_attribute :image_file_name}
  it {is_expected.to have_attribute :image_content_type}
  it {is_expected.to have_attribute :image_file_size}
  it {is_expected.to have_attribute :image_updated_at}
  it {is_expected.to have_attribute :image_url_original}
  it {is_expected.to have_attribute :image_url_thumb}

  it {is_expected.to filter :created_at}
  it {is_expected.to filter :updated_at}
  it {is_expected.to filter :amount}
  it {is_expected.to filter :activity}
  it {is_expected.to filter :votes_count}
  it {is_expected.to filter :api_user_voted}
  it {is_expected.to filter :image_url_original}
  it {is_expected.to filter :image_url_thumb}
  it {is_expected.to filter :image_file_name}
  it {is_expected.to filter :image_content_type}
  it {is_expected.to filter :image_file_size}
  it {is_expected.to filter :image_updated_at}

  it {is_expected.to have_one :sender}
  it {is_expected.to have_one :receiver}
  it {is_expected.to have_one :balance}
end
