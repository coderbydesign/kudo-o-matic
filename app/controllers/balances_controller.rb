# frozen_string_literal: true

class BalancesController < ApplicationController
  before_action :check_team_member_rights

  def index
    @balances = current_team.balances.order('created_at DESC')
    @current_balance = @balances.where(current: true)
  end

  def show
    @balances = current_team.balances.order('created_at DESC')
    @balance = @balances.find(params[:id])
  end

  def new
    @balance = Balance.new
  end

  def create
    @balance = Balance.new(balance_params)
    @balance.team_id = current_team.id
    if @balance.save
      check_if_current_exists?(@balance)
      redirect_to balance_path(id: @balance.id, team: current_team.slug)
    else
      render :new
    end
  end

  def edit
    @balance = current_team.balances.find(params[:id])
  end

  def update
    @balance = current_team.balances.find(params[:id])
    return if deactivate_current_balance?(@balance)

    if @balance.update_attributes(balance_params)
      check_if_current_exists?(@balance)
      redirect_to balance_path(id: @balance.id, team: current_team.slug), notice: 'Balance updated!'
    else
      render :edit
    end
  end

  def destroy
    @balance = current_team.balances.find(params[:id])
    @balances = current_team.balances

    if @balance.current
      flash[:error] = "Active balance can't be deleted"
    else
      @balance.destroy
      flash[:success] = 'Balance successfully deleted!'
    end

    redirect_to balances_path(team: current_team.slug)
  end

  private

  def check_if_current_exists?(balance)
    @current_balance = current_team.balances.where.not(id: balance.id).where(current: true)
    return if @current_balance.count == 0
    if balance_params['current'] == "1"
      @current_balance.order("updated_at desc").last.update(current: false)
    end
  end

  def deactivate_current_balance?(balance)
    if balance_params['current'] == "0" && balance.current;
      flash[:error] = "You can't unset a balance to not current if it is set to current."
      redirect_to edit_balance_path(id: @balance.id, team: current_team.slug) and return true
    end
  end

  def balance_params
    params.required(:balance).permit(:name, :current)
  end
end
