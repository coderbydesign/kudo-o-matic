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
      if no_admin_left?
        flash[:error] = 'You can not degrade this administrator to a normal user because there are no other administrators.'
        redirect_back(fallback_location: root_path)
        return
      end

      super
    end

    def destroy
      if no_admin_left?
        flash[:error] = 'You can not delete this user because there are no other administrators.'
        redirect_to admin_users_path
        return
      end

      super
    end

    def no_admin_left?
      User.all.where(admin: true).count <= 1
    end
  end
end
