class ActivitiesController < ApplicationController
  def autocomplete_search
    @activities = Activity.order(:name).where("lower(name) like ?", "#{params[:term]}%".downcase)
    render json: @activities.map(&:name)
  end
end
