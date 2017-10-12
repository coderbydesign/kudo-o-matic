require 'rails_helper'
require 'shared/controllers/admin/shared_expectations'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user) {create(:user, :admin)}

  before do
    sign_in user
  end

  describe 'PATCH #update' do
    let (:perform_update) {patch :update, params: {id: user.id, user: user.attributes}}

    context 'upgrading an administrator to a normal user' do
      before do
        user.admin = false
      end

      context 'with at least one other administrator left' do
        let!(:administrator) {create(:user, :admin)}
        let! (:record_count_before_request) {User.count}

        before do
          perform_update
        end

        it 'degrades the administrator to a normal user' do
          expect(User.find(user.id).admin).not_to eq(true)
        end

        expect_user_count_same

        it 'redirects back to the admin user path' do
          expect(response).to redirect_to(admin_user_path)
        end
      end

      context 'with no other administrators left' do
        let! (:record_count_before_request) {User.count}

        before do
          perform_update
        end

        it 'does not degrade the administrator to a normal user' do
          expect(User.find(user.id).admin).to eq(true)
        end

        expect_user_count_same

        it 'redirects back to the edit admin user path ' do
          expect(response).to redirect_to(edit_admin_user_path(user.id))
        end
      end
    end
  end

  describe 'PATCH #deactivate' do
    let (:perform_deactivate) {patch :deactivate, params: {id: user.id}}

    context 'deactivating an active user' do
      context 'with at least one other administrator left' do
        let!(:administrator) {create(:user, :admin)}
        let! (:record_count_before_request) {User.count}

        before do
          perform_deactivate
        end

        it 'deactivates the user' do
          expect(User.find(user.id).deactivated_at).not_to be_nil
        end

        expect_user_count_same

        it 'redirects back to admin users path' do
          expect(response).to redirect_to(admin_users_path)
        end
      end

      context 'with no other administrators left' do
        let! (:record_count_before_request) {User.count}

        before do
          perform_deactivate
        end

        it 'does not deactivate the administrator' do
          expect(User.find(user.id).deactivated_at).to be_nil
        end

        expect_user_count_same

        it 'redirects back to the admin users path' do
          expect(response).to redirect_to(admin_users_path)
        end
      end
    end
  end

  describe 'PATCH #reactivate' do
    let (:perform_reactivate) {patch :reactivate, params: {id: user.id}}
    let! (:record_count_before_request) {User.count}

    before do
      user.deactivated_at = DateTime.now

      perform_reactivate
    end

    context 'activating a deactivated user' do
      it 'actives the user' do
        expect(User.find(user.id).deactivated_at).to be_nil
      end

      expect_user_count_same

      it 'returns back to the admin users path' do
        expect(response).to redirect_to(admin_users_path)
      end
    end
  end
end
