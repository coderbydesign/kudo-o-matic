require 'rails_helper'
require 'jsonapi/resources/matchers'

RSpec.describe Api::V1::VoteResource, type: :resource do
  let (:vote) {create(:vote)}
  subject {described_class.new(vote, {})}

  it {is_expected.to have_primary_key :id}

  it {is_expected.to have_attribute :votable_type}
  it {is_expected.to have_attribute :votable_id}
  it {is_expected.to have_attribute :voter_type}
  it {is_expected.to have_attribute :voter_id}
  it {is_expected.to have_attribute :vote_flag}
  it {is_expected.to have_attribute :vote_scope}
  it {is_expected.to have_attribute :vote_weight}

  it {is_expected.to filter :votable_type}
  it {is_expected.to filter :votable_id}
  it {is_expected.to filter :voter_type}
  it {is_expected.to filter :voter_id}
  it {is_expected.to filter :vote_flag}
  it {is_expected.to filter :vote_scope}
  it {is_expected.to filter :vote_weight}

  it {is_expected.to have_one :user_voter}
  it {is_expected.to have_one :transaction_votable}
end
