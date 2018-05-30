require 'rails_helper'

describe BalanceDecorator do
  let!(:prev_goal) { create :goal, amount: 500 }
  let!(:next_goal) { create :goal, amount: 1000 }
  let(:activity) { Activity.create name: 'Helping with RSpec' }
  let(:team) { create :team }
  let(:user) { User.create name: 'Pascal', avatar_url: '/kabisa_lizard.png' }
  let(:balance) { create :balance, current: :current, team_id: team.id }
  let!(:transaction) { Transaction.create sender: user, receiver: user, team_id: team.id, activity: activity, amount: 100, balance: balance}
  let!(:transaction_2) { Transaction.create sender: user, receiver: user, team_id: team.id, activity: activity, amount: 100, balance: balance}
  let!(:transaction_3) { Transaction.create sender: user, receiver: user, team_id: team.id, activity: activity, amount: 500, balance: balance}

  subject { balance.decorate }

  before do
    team.add_member(user)
  end

  it 'renders amount in Kudos' do
    @transaction_amount = Transaction.where(balance: Balance.current(team.id)).sum(:amount)
    expect(@transaction_amount).to eq(700)
  end
end
