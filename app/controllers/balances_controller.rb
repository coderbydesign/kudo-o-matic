# frozen_string_literal: true

class BalancesController < ApplicationController
  def index
    @balances = current_team.balances.order('created_at DESC')
  end

  def show
    @balance = current_team.balances.find(params[:id])
  end

  def new
    @balance = Balance.new
  end

  def create
    @balance = Balance.new(balance_params)
    @balance.team_id = current_team.id
    if @balance.save
      redirect_to balances_path, team: current_team.slug
    else
      render :new
    end
  end

  def edit
    @balance = current_team.balances.find(params[:id])
  end

  def update
    @balance = current_team.balances.find(params[:id])
    if @balance.update_attributes(balance_params)
      flash[:success] = 'Balance updated!'
      redirect_to balances_path, team: current_team.slug
    else
      render :edit
    end
  end

  def destroy
    @balance = current_team.balances.find(params[:id])
    @balance.destroy

    redirect_to balances_path(team: current_team.slug)
  end

  private

  def balance_params
    params.required(:balance).permit(:name)
  end
end
