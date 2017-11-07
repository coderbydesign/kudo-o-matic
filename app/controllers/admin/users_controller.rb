module Admin
  class UsersController < Admin::ApplicationController
    before_action :set_user, only: [:update, :deactivate, :reactivate]

    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = User.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   User.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    def update
      begin
        @user.update(user_params)
        redirect_to admin_user_path
      rescue Exception => e
        flash[:error] = e.message
        redirect_back(fallback_location: edit_admin_user_path)
      end
    end

    def deactivate
      begin
        @user.deactivate
        redirect_to admin_users_path
      rescue Exception => e
        flash[:error] = e.message
        redirect_back(fallback_location: admin_users_path)
      end
    end

    def reactivate
      @user.reactivate
      redirect_back(fallback_location: admin_users_path)
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :slack_name, :avatar_url, :admin, :transaction_received_mail, :goal_reached_mail, :summary_mail, 'api_token')
    end
  end
end
