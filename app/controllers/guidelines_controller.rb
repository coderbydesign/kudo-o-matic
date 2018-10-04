class GuidelinesController < ApplicationController
  # before_action :set_guideline, only: [:create, :update]
  before_action :check_team_member_rights, except: [:kudo_guidelines]

  def index
    @guidelines = current_team.guidelines.order('kudos DESC').page(params[:page]).per(20)
    @guideline = Guideline.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @guideline = Guideline.new(guideline_params)
    @guideline.team_id = current_team.id
    if @guideline.save
      flash[:success] = "Successfully created guideline!"
    else
      flash[:error] = "Something went wrong, please try again."
    end
    redirect_to guidelines_path(team: current_team.slug)
  end

  def edit
    @guideline = current_team.guidelines.find(params[:id])
  end

  def destroy
    @guideline = current_team.guidelines.find(params[:id])
    if @guideline.destroy
      flash[:success] = 'Succesfully removed guideline!'
    end
    redirect_to guidelines_path(team: current_team.slug)
  end

  def update
    @guideline = current_team.guidelines.find(params[:id])
    if @guideline.update(guideline_params)
      flash[:success] = 'Successfully updated transaction!'
    end
    redirect_to guidelines_path(team: current_team.slug)
  end

  def kudo_guidelines
    kudos = params[:kudo_amount].to_i
    guidelines = Guideline.guidelines_between [(kudos - 10), 0].max, kudos + 10, current_team.id
    render json: guidelines
  end

  private

  def guideline_params
    params.require(:guideline).permit(:name, :kudos)
  end
end