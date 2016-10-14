require 'rails_helper'

describe TransactionDecorator do
  let(:sender) { create :sender, name: "Harry" }
  let(:receiver) { create :sender, name: "William" }
  let(:activity) { create :activity, name: "writing a blog post" }

  let!(:transaction) {
    create :transaction,
      amount: 42,
      activity: activity,
      sender: sender,
      receiver: receiver
  }

  subject { transaction.decorate }

  it 'to_s' do
    expect(subject.to_s).to eq("42 ₭ from HARRY to WILLIAM for WRITING A BLOG POST")
  end
end

