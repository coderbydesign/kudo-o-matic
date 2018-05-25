require 'rails_helper'

RSpec.describe Goal, type: :model do

  # Skip the after_create callback in this spec, because we are working with specific balances and goals
  before do
    Team.skip_callback(:create, :after, :create_balances_and_goals)
  end

  # After this spec, set the callback again, so other specs can make use of it
  after do
    Team.set_callback(:create, :after, :create_balances_and_goals)
  end

  context '.previous and .next goals' do
    let!(:team) { create(:team) }
    let!(:old_balance)   { create :balance, name: 'closed balance', current: false, team_id: team.id  }
    let!(:current_balance)   { create :balance, name: 'current balance', current: true, team_id: team.id  }
    let!(:old_goal)   { create :goal, :achieved, achieved_on: 100.days.ago, amount: 600, balance: old_balance }
    let!(:goal_one)   { create :goal, :achieved, achieved_on: 60.days.ago, amount: 100, balance: current_balance }
    let!(:goal_two)   { create :goal, :achieved, achieved_on: 30.day.ago, amount: 200,  balance: current_balance }
    let!(:goal_three) { create :goal, amount: 300,  balance: current_balance }
    let!(:goal_four)  { create :goal, amount: 400,  balance: current_balance }

    it 'finds the previous goal' do
      expect(Goal.previous(team)).to eq(goal_two)
    end

    it 'finds the next goal' do
      expect(Goal.next(team)).to eq(goal_three)
    end
  end

  context '#achieve' do
    let(:goal) { create :goal }

    it 'marks goals as achieved' do
      expect {
        goal.achieve!
      }.to change { goal.achieved? }.from(false).to(true)
    end
  end
end
