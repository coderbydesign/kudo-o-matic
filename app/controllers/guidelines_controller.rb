class GuidelinesController < ApplicationController
  before_action :set_guideline, only: [:create, :update]

  def create
    @guideline = Guideline.new(params[:guideline], teams_id: current_team.id)

    if @guideline.save
      # redirect_to :dashboard, team: current_team.slug
      # ?
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def destroy
    if @guideline.delete
      flash[:success] = 'Succesfully removed guideline!'
    end
    redirect_to root_path
  end

  def update
    if @guideline.update(guideline_params)
      flash[:success] = 'Successfully updated transaction!'
    end
    redirect_to @guideline
  end

  private

  def set_guideline
    @guideline = Guideline.find_by_id_and_team_id(params[:id], current_team.id)
  end

  def guideline_params
    params.require(:guideline).permit(:name, :kudos)
  end
end