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
      begin
        @balance.update(balance_params)
        redirect_to admin_balance_path
      rescue Exception => e
        flash[:error] = e.message
        redirect_back(fallback_location: edit_admin_balance_path)
      end
    end

    def destroy
      begin
        @balance.destroy
        redirect_to admin_balances_path
      rescue Exception => e
        flash[:error] = e.message
        redirect_back(fallback_location: admin_balances_path)
      end
    end

    private

    def set_balance
      @balance = Balance.find(params[:id])
    end

    def balance_params
      params.require(:balance).permit(:name, :current)
    end
  end
end
