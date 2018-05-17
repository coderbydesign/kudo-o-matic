require 'rails_helper'

RSpec.describe GoalReacher, type: :model do
  let!(:team) { create(:team) }
  let!(:user) { User.create name: 'John', email:'johndoe@example.com' }
  let!(:user_2) { User.create name: 'Jane', email:'janedoe@example.com' }
  let(:user_goal) { User.create name: 'Kabisa' }
  let(:activity) { Activity.create name:'Helping me with Rspec' }
  let(:balance) { create :balance, current: true, team_id: team.id }
  let!(:goal) { create :goal, name:'BBQ', amount: 500, achieved_on: nil, balance: balance }
  let!(:goal_2) { create :goal, name:'goal_2', amount: 1000, achieved_on: nil, balance: balance }

  before do
    team.add_member user
    team.add_member user_2
  end

  context 'The next goal is achieved' do

    let!(:transaction) { create :transaction, sender: user, receiver: user, amount: 600, activity: activity, balance: balance }
    let!(:transaction_2) { create :transaction, sender: user, receiver: user, amount: 100, activity: activity, balance: balance }

    it 'marks the next goal as achieved' do
      GoalReacher.check!(team)
      expect(Goal.previous(team)).to eq(goal)
    end

    it 'sends an email' do
      GoalMailer.goal_email(user, team, goal).deliver_now
      expect(ActionMailer::Base.deliveries.count).to be(1)
    end

    # Skipped because of unused function Transaction.goal_reached_transaction
    xit 'creates a transaction for the reached goal' do
      GoalReacher.check!(team)
      expect(Transaction.last.activity.name).to eq("reaching the goal #{Goal.previous(team).name} :boom:, here are some ₭udos to boost your hunt for the next goal")
    end
  end
end