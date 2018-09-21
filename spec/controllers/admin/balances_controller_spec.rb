require 'rails_helper'
require 'shared/controllers/admin/shared_expectations'

RSpec.describe Admin::BalancesController, type: :controller do
  let!(:team) {create :team}
  let!(:balance) {Balance.current(team)}
  let!(:balance2) {Balance.create team: team, name: 'Balance 2'}
  let!(:user) {create(:user, :admin)}

  before do
    sign_in user
  end

  describe 'PATCH #update' do

    let (:perform_update) {patch :update, params: {id: balance.id, balance: balance.attributes}}

    context 'updating the a current balance to a non-current balance' do
      before do
        # balance.current = false
      end

      context 'with at least one other current balance left' do
        let! (:record_count_before_request) {Balance.count}
        before do
          perform_update
        end

        it 'cant remove the only current balance attached to this team' do
          expect(Balance.find(balance.id).current).to eq(true)
        end

        expect_balance_count_same
      end

      context 'with no other current balances left' do
        let! (:record_count_before_request) {Balance.count}

        before do
          perform_update
        end

        it 'does not update the current balance to a normal balance' do
          expect(Balance.find(balance.id).current).to eq(true)
        end

        it 'redirects back to the edit admin balance path ' do
          expect(response).to redirect_to(admin_balance_path)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let (:perform_delete) {delete :destroy, params: {id: balance2.id}}
    let (:perform_delete_active) {delete :destroy, params: {id: balance.id}}

    context 'deleting the last current balance' do
      context 'with at least one other current balance left' do
        let!(:current_balance) {create(:balance, :current)}
        let! (:record_count_before_request) {Balance.count}

        before do
          perform_delete
        end

        it 'deletes the current balance' do
          expect {Balance.find(balance2.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        expect_balance_count_decrease

        it 'redirects back to the admin balances path' do
          expect(response).to redirect_to(admin_balances_path)
        end
      end

      context 'with no other current balances left' do
        let! (:record_count_before_request) {Balance.count}

        before do
          perform_delete_active
        end

        it 'does not delete the current balance' do
          expect(Balance.find(balance.id)).to eq(balance)
        end

        expect_balance_count_same

        it 'redirects back to the admin balances path' do
          expect(response).to redirect_to(admin_balances_path)
        end
      end
    end
  end
end
