require 'rails_helper'

RSpec.describe DeviseHelper, type: :helper do
  describe 'unconfirmed_access_hours_left' do
    let(:user) { create(:user) }

    context 'with a brand new account' do
      it 'returns 24' do
        expect(unconfirmed_access_hours_left(user)).to eq(24)
      end
    end

    context 'with a 1 day old account' do
      it 'returns 0' do
        user.confirmation_sent_at -= 1.day
        expect(unconfirmed_access_hours_left(user)).to eq(0)
      end
    end
  end
end
