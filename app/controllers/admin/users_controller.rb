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

    def update
      if params[:user][:admin] && no_admin_left? # check if the user is actually updating the admin property
        flash[:error] = "Can't degrade this administrator to a normal user because there are no other administrators"
        redirect_back(fallback_location: edit_admin_user_path)
      else
        super
      end
    end

    def destroy
      if no_admin_left?
        flash[:error] = "Last administrator can't be removed"
        redirect_back(fallback_location: admin_users_path)
      else
        super
      end
    end

    private

    def no_admin_left?
      # condition is evaluated before update and destroy, so the admin count needs to be less or equal to 1
      User.where(admin: true).count <= 1
    end
  end
end
