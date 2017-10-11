require 'rails_helper'

RSpec.describe Admin::BalancesController, type: :controller do
  let!(:balance) {create(:balance, :current)}
  let!(:user) {create(:user, :admin)}

  def current_balance_count
    Balance.where(current: true).count
  end

  before do
    sign_in user

    balance.current = false
  end

  describe 'PATCH #update' do
    let (:perform_update) {patch :update, params: {id: balance.id, balance: balance.attributes}}

    context 'with at least one other current balance left' do
      let!(:current_balance) {create(:balance, :current)}

      it 'successfully updates the current balance to a normal balance' do
        expect {perform_update}.to change {current_balance_count}
      end

      it 'redirects back to admin balance path' do
        perform_update

        expect(response).to redirect_to(admin_balance_path)
      end
    end

    context 'with no other current balances left' do
      it 'does not update the current balance to a normal balance' do
        expect {perform_update}.not_to change {current_balance_count}
      end

      it 'redirects back to the edit admin balance page ' do
        perform_update

        expect(response).to redirect_to(edit_admin_balance_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let (:perform_delete) {delete :destroy, params: {id: balance.id}}

    context 'with at least one other current balance left' do
      let!(:current_balance) {create(:balance, :current)}

      it 'successfully deletes the current balance' do
        expect {perform_delete}.to change {current_balance_count}
      end

      it 'redirects back to admin balances path' do
        perform_delete

        expect(response).to redirect_to(admin_balances_path)
      end
    end

    context 'with no other current balances left' do
      it 'does not delete the current balance' do
        expect {perform_delete}.not_to change {current_balance_count}
      end

      it 'redirects back to the admin balances path' do
        perform_delete

        expect(response).to redirect_to(admin_balances_path)
      end
    end
  end
end
