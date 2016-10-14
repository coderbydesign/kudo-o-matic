require 'rails_helper'

RSpec.describe Goal, type: :model do
  context '.previous and .next goals' do
    let!(:goal_one)   { create :goal, :achieved, achieved_on: 60.days.ago, amount: 100 }
    let!(:goal_two)   { create :goal, :achieved, achieved_on: 30.day.ago, amount: 200 }
    let!(:goal_three) { create :goal, amount: 300 }
    let!(:goal_four)  { create :goal, amount: 400 }

    it 'finds the previous goal' do
      expect(Goal.previous).to eq(goal_two)
    end

    it 'finds the next goal' do
      expect(Goal.next).to eq(goal_three)
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
