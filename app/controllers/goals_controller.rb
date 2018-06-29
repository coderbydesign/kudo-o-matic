# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = current_team.goals.order('created_at DESC')
  end

  def show
    @goal = current_team.goals.find(params[:id])
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    if @goal.save
      redirect_to goal_path(id: @goal.id, team: current_team.slug)
    else
      render :new
    end
  end

  def edit
    @goal = current_team.goals.find(params[:id])
  end

  def update
    @goal = current_team.goals.find(params[:id])
    if @goal.update_attributes(goal_params)
      flash[:success] = 'Goal updated!'
      redirect_to goal_path(id: @goal.id, team: current_team.slug)
    else
      render :edit
    end
  end

  def destroy
    @goal = current_team.goals.find(params[:id])
    @goal.destroy

    redirect_to goals_path(team: current_team.slug)
  end

  private

  def goal_params
    params.required(:goal).permit(:name, :amount, :balance_id)
  end
end
