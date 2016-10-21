require 'rails_helper'

describe GoalDecorator do
  let(:goal) { create :goal, name: "tennis", amount: 1500 }

  subject { goal.decorate }

  it 'upcases the name' do
    expect(subject.name).to eq('TENNIS')
  end

  it 'formats kudos amount' do
    expect(subject.kudos).to eq('1.500 ₭')
  end
end
