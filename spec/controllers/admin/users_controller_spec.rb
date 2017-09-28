require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user) {create(:user, :admin)}

  def admin_count
    User.where(admin: true).count
  end

  before do
    sign_in user

    user.admin = false
  end

  describe 'PATCH #update' do
    let (:perform_update) {patch :update, params: {id: user.id, user: user.attributes}}

    context 'with at least one other administrator left' do
      let!(:administrator) {create(:user, :admin)}

      it 'successfully degrades the administrator to a normal user' do
        expect {perform_update}.to change {admin_count}
      end

      it 'redirects back to admin user path' do
        perform_update

        expect(response).to redirect_to(admin_user_path)
      end
    end

    context 'with no other administrators left' do
      it 'does not degrade the administrator to a normal user' do
        expect {perform_update}.not_to change {admin_count}
      end

      it 'redirects back to the edit admin user page ' do
        perform_update

        expect(response).to redirect_to(edit_admin_user_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let (:perform_delete) {delete :destroy, params: {id: user.id}}

    context 'with at least one other administrator left' do
      let!(:administrator) {create(:user, :admin)}

      it 'successfully deletes the administrator' do
        expect {perform_delete}.to change {admin_count}
      end

      it 'redirects back to admin users path' do
        perform_delete

        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'with no other administrators left' do
      it 'does not delete the administrator' do
        expect {perform_delete}.not_to change {admin_count}
      end

      it 'redirects back to the admin users path' do
        perform_delete

        expect(response).to redirect_to(admin_users_path)
      end
    end
  end
end
