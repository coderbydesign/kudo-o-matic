require 'rails_helper'

describe BalanceDecorator do
  let!(:prev_goal) { create :goal, :achieved, amount: 500 }
  let!(:next_goal) { create :goal, amount: 1500 }

  let(:balance) { create :balance, amount: 1234 }

  subject { balance.decorate }

  it 'renders amount in Kudos' do
    expect(subject.kudos).to eq('1.234 ₭')
  end

  it 'returns the completion percentage' do
    expect(subject.percentage).to eq(73)
  end
end
