# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BalancesController, type: :controller do
  let!(:user) { create(:user, :admin) }
  let!(:user_unauthorized) { create(:user)}
  let!(:team) { create(:team) }
  let!(:team2) { create(:team, name: 'The Company', slug: 'the-company') }
  let!(:balance) { create :balance, current: :current, team_id: team.id }
  let!(:balance2) { create :balance, current: false, team_id: team.id }
  let!(:goal) { create(:goal) }

  before do
    sign_in user
  end


  describe 'DELETE #delete' do
    context "as team manager" do
      before do
        team.add_member(user, true)
      end

      it 'deletes a balance' do
        expect {
          delete 'destroy', id: balance2.id, team: team.slug
        }.to change(Balance, :count).by(-1)
      end
    end

    context "as not team manager" do
      before do
        team.add_member(user)
      end

      it 'not deletes a balance' do
        expect {
          delete 'destroy', id: balance2.id, team: team.slug
        }.to change(Balance, :count).by(0)
      end
    end
  end
end
