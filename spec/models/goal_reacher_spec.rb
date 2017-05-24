require 'rails_helper'

RSpec.describe GoalReacher, type: :model do
  let(:user) { User.create name: 'John' }
  let(:activity) { Activity.create name:'Helping me with Rspec' }
  let(:balance) { create :balance, :current }
  let!(:goal) { create :goal, name:'goal', amount: 500, achieved_on: nil }
  let!(:goal_2) { create :goal, name:'goal_2', amount: 1000, achieved_on: nil }
  let!(:transaction) { Transaction.create sender: user, receiver: user, amount: 600, activity: activity }

  describe '#check!' do
    xit 'marks the next goal as achieved' do
      GoalReacher.check!
      expect(goal).to be(achieved_on: 'bla')
    end
  end
end
