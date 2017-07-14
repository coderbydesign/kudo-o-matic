module Admin
  class UsersController < Admin::ApplicationController
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

    def destroy
      # @user = User.find(params[:id])
      if User.all.where(admin: true).count <= 1
        flash[:error] = 'You can not delete this user because there is no other administrator.'
        redirect_to admin_users_path
        return
      end
      super
    end

    def update
      super
    end
  end
end
