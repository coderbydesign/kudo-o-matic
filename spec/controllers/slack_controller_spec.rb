require 'rails_helper'

RSpec.describe SlackController, type: :controller do
  let!(:invalid_token) { -1 }

  describe 'POST #action' do
    let!(:user) { create(:user, slack_id: 1) }
    let!(:team) { create(:team) }
    let!(:balance) { Balance.current(team) }
    let!(:new_transaction) { create(:transaction, team_id: team.id, balance: balance) }
    let!(:invalid_user_slack_id) { -1 }

    before do
      team.add_member(user)
      ENV['SLACK_VERIFICATION_TOKEN'] = '1'
      ENV['SLACK_REACTION'] = 'kudo'
    end

    context 'with a valid verification token' do
      context 'and a valid transaction (callback) id' do
        context 'and a valid user slack id' do
          it 'adds a like to the transaction as the user' do
            post :action, params: {
              payload: {
                token: ENV['SLACK_VERIFICATION_TOKEN'],
                callback_id: new_transaction.id,
                user: {
                  id: user.slack_id
                }
              }.to_json
            }

            transaction = Transaction.find(self.new_transaction.id)
            user = User.find_by_slack_id(self.user.slack_id)

            expect(user.voted_for? transaction).to be true
          end
        end

        context 'and an invalid user slack id' do
          it 'does not add a like to the transaction' do
            post :action, params: {
              payload: {
                token: ENV['SLACK_VERIFICATION_TOKEN'],
                callback_id: new_transaction.id,
                user: {
                  id: invalid_user_slack_id
                }
              }.to_json
            }

            transaction = Transaction.find(self.new_transaction.id)
            user = User.find_by_slack_id(self.user.slack_id)

            expect(user.voted_for? transaction).to be false
          end
        end
      end
    end

    context 'with an invalid verification token' do
      context 'and a valid transaction (callback) id' do
        context 'and a valid user slack id' do
          it 'does not add a like to the transaction' do
            post :action, team: team.slug, params: {
              payload: {
                token: invalid_token,
                callback_id: new_transaction.id,
                user: {
                  id: user.slack_id
                }
              }.to_json
            }

            transaction = Transaction.find(self.new_transaction.id)
            user = User.find_by_slack_id(self.user.slack_id)

            expect(user.voted_for? transaction).to be false
          end
        end
      end
    end
  end

  describe 'POST #command' do
    let!(:balance) { create(:balance, current: true) }
    let!(:sender) { create(:user, slack_id: 1) }
    let!(:team) { create :team }
    let!(:receiver) { create(:user, slack_name: 'receiver') }
    let!(:record_count_before_request) { Transaction.count }

    before do
      team.add_member(sender)
      team.add_member(receiver)
      ENV['SLACK_VERIFICATION_TOKEN'] = '1'
    end

    RSpec::Expectations.configuration.on_potential_false_positives = :nothing

    context 'with a valid verification token' do
      context 'and valid command arguments' do
        before do
          post :command, params: {
            token: ENV['SLACK_VERIFICATION_TOKEN'],
            text: '@receiver 1 test',
            user_id: sender.slack_id
          }
        end

        it 'does create a new transaction with the correct values' do
          transaction = Transaction.last

          expect(transaction.amount).to equal(1)
          expect(transaction.activity.name).to match('test')
          expect(transaction.sender.id).to eq(sender.id)
          expect(transaction.receiver.id).to eq(receiver.id)
        end

        it 'does increase the transaction record count' do
          expect(record_count_before_request).to be < Transaction.count
        end
      end

      context 'and no command arguments' do
        it 'raises an error' do
          expect {
            post :command, params: {
              token: ENV['SLACK_VERIFICATION_TOKEN'],
              text: ''
            }.to_json
          }.to raise_error
        end
      end

      context 'and a space as a command argument' do
        it 'raises an error' do
          expect {
            post :command, params: {
              token: ENV['SLACK_VERIFICATION_TOKEN'],
              text: ' '
            }.to_json
          }.to raise_error
        end
      end

      context 'and help as a command argument' do
        context 'in uppercase' do
          it 'raises an error' do
            expect {
              post :command, params: {
                token: ENV['SLACK_VERIFICATION_TOKEN'],
                text: 'HELP'
              }.to_json
            }.to raise_error
          end
        end

        context 'in lowercase' do
          it 'raises an error' do
            expect {
              post :command, params: {
                token: ENV['SLACK_VERIFICATION_TOKEN'],
                text: 'help'
              }.to_json
            }.to raise_error
          end
        end
      end
    end

    context 'with an invalid verification token' do
      before do
        post :command, params: {
          token: invalid_token,
          text: '1 to @receiver for test',
          user_id: sender.slack_id
        }
      end

      it 'does not change the transaction record count' do
        expect(record_count_before_request).to be == Transaction.count
      end
    end
  end

  describe 'POST #reaction' do
    let!(:user) { create(:user, slack_id: 1) }
    let!(:team) { create :team }
    let!(:transaction) { create(:transaction, slack_reaction_created_at: DateTime.now, team_id: team.id) }
    let!(:invalid_reaction) { 'invalid' }

    before do
      team.add_member(user)
      ENV['SLACK_VERIFICATION_TOKEN'] = '1'
    end

    context 'with a valid verification token' do
      context 'and a valid reactji' do
        context 'and an existing transaction that was created with a valid reactji' do
          it 'likes the existing transaction' do
            post :reaction, params: {
              token: ENV['SLACK_VERIFICATION_TOKEN'],
              event: {
                user: user.slack_id,
                reaction: 'kudo',
                item: {
                  ts: transaction.slack_reaction_created_at
                }
              }
            }

            transaction = Transaction.find_by_slack_reaction_created_at(self.transaction.slack_reaction_created_at)
            user = User.find_by_slack_id(self.user.slack_id)

            expect(user.voted_for? transaction).to be true
          end
        end
      end

      context 'without a valid reactji' do
        context 'and an existing transaction that was created with a valid reactji' do
          it 'does not like the existing transaction' do
            post :reaction, params: {
              token: ENV['SLACK_VERIFICATION_TOKEN'],
              event: {
                user: user.slack_id,
                reaction: invalid_reaction,
                item: {
                  ts: transaction.slack_reaction_created_at
                }
              }
            }

            transaction = Transaction.find_by_slack_reaction_created_at(self.transaction.slack_reaction_created_at)
            user = User.find_by_slack_id(self.user.slack_id)

            expect(user.voted_for? transaction).to be false
          end
        end
      end
    end

    context 'with an invalid verification token' do
      context 'and a valid reactji' do
        context 'and an existing transaction that was created with a valid reactji' do
          it 'does not like the existing transaction' do
            post :reaction, params: {
              token: invalid_token,
              event: {
                user: user.slack_id,
                reaction: 'kudo',
                item: {
                  ts: transaction.slack_reaction_created_at
                }
              },
            }

            transaction = Transaction.find_by_slack_reaction_created_at(self.transaction.slack_reaction_created_at)
            user = User.find_by_slack_id(self.user.slack_id)

            expect(user.voted_for? transaction).to be false
          end
        end
      end
    end
  end
end
