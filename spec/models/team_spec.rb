require 'rails_helper'

RSpec.describe Team, type: :model do
  context 'given a team and user' do
    let(:team) { create :team }
    let(:user) { create :user }

    it 'adds and removes a member' do
      team.add_member(user, true)
      expect(user.memberships.any?).to be true

      team.remove_member user
      expect(user.memberships.any?).to be false
    end
  end
end
