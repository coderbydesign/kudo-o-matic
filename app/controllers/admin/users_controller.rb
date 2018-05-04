module Admin
  class UsersController < Admin::ApplicationController
    before_action :set_user, only: [:update, :deactivate, :reactivate]

    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(scoped_resource,
                                           dashboard_class,
                                           search_term).run
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      resources = resources.where(restricted: false)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
        show_search_bar: show_search_bar?
      }
    end

    def show
      render locals: {
          page: Administrate::Page::Show.new(dashboard, requested_resource.decorate),
      }
    end

    # Define a custom finder by overriding the `find_resource` method:
    def find_resource(param)
      User.find_by!(id: param, restricted: false)
    end

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
