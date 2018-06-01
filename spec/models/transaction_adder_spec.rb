require 'rails_helper'

describe TransactionAdder, type: :model do
  let(:application) { create(:application) }
  let(:user) { create(:user) }
  let(:user2) { create(:user, name: 'Ruud') }
  let(:user3) { create(:user, name: 'Henk') }
  let(:team) { create :team }
  let(:token) do
    Doorkeeper::AccessToken.create! application_id: application.id,
                                    resource_owner_id: user2.id
  end
  let!(:transaction) { build(:transaction, team_id: team.id) }

  before do
    team.add_member(user)
    team.add_member(user2)
    team.add_member(user3)
  end

  describe '#create_from_api_request' do
    # This test shows the bug where a transaction with the wrong sender is made
    # It occurs because the Api-Token header is missing in API V2, which results
    # in the following database query:
    #
    # SELECT  "users".* FROM "users" WHERE "users"."api_token" IS NULL LIMIT 1
    # So it gets ALL users and then the ordering (created_at) decides which user
    #
    # The sender name should equal to Ruud, but it equals to John, the first user
    context 'with a missing Api-Token header' do
      it 'creates a transaction with the wrong sender' do
        headers = {
          'Authorization': "Bearer #{token.token}", # Ruud
          'Content-Type': 'application/vnd.api+json',
          'Team': "#{team.id}"
        }
        params = {
          data: {
            type: 'transactions',
            attributes: {
              amount: transaction.amount,
              activity: transaction.activity.name,
              image: Base64.encode64(File.open(Rails.root + 'spec/fixtures/images/rails.png') { |io| io.read }),
              'image-file-type': 'png'
            },
            relationships: {
              receiver: {
                data: {
                  type: 'users',
                  name: user.name # John
                }
              }
            }
          }
        }
        transaction = TransactionAdder.create_from_api_request(headers, params)
        expect(transaction.sender.name).to_not eq(user2.name)
      end
    end
  end

  describe '#create_from_api_v2_request' do
    # This shows that the new method `create_from_v2_api_request`, creates a
    # transaction with the right sender. In the controller, the user is given to us by Doorkeeper.
    it 'creates a transaction with the right sender' do
      params = {
        data: {
          type: 'transactions',
          attributes: {
            amount: transaction.amount,
            activity: transaction.activity.name,
            image: Base64.encode64(File.open(Rails.root + 'spec/fixtures/images/rails.png') { |io| io.read }),
            'image-file-type': 'png'
          },
          relationships: {
            receiver: {
              data: {
                type: 'users',
                name: user.name
              }
            }
          }
        }
      }
      transaction = TransactionAdder.create_from_api_v2_request(user2, team, params)
      expect(transaction.sender.name).to eq(user2.name)
    end
  end
end
