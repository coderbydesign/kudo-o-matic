module Admin
  class BalancesController < Admin::ApplicationController
    before_action :set_balance, only: [:update, :destroy]

    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Balance.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Balance.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    def update
      redirect_to admin_balance_path and return if deactivate_current_balance?(@balance)
      begin
        check_if_current_exists?(@balance)
        @balance.update(balance_params)
        redirect_to admin_balance_path
      rescue Exception => e
        flash[:error] = e.message
        redirect_back(fallback_location: edit_admin_balance_path)
      end
    end

    def destroy
      if @balance.current
        flash[:error] = "Active balance can't be deleted"
      elsif @balance.destroy
        flash[:success] = 'Balance successfully deleted!'
      else
        flash[:error] = "Something went wrong, please try again"
      end
      redirect_to admin_balances_path
    end

    private

    def set_balance
      @balance = Balance.find(params[:id])
    end

    def balance_params
      params.require(:balance).permit(:name, :current)
    end

    def check_if_current_exists?(balance)
      @current_balance = balance.team.balances.where.not(id: balance.id).where(current: true)
      return if @current_balance.count == 0
      if balance_params['current'] == "1"
        @current_balance.order("updated_at desc").last.update(current: false)
      end
    end

    def deactivate_current_balance?(balance)
      if balance_params['current'] == "0" && balance.current;
        flash[:error] = "You can't unset a balance to not current if it is set to current."
        redirect_to edit_admin_balance_path and return true
      end
    end
  end
end
