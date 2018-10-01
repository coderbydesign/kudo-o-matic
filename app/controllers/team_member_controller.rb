# frozen_string_literal: true

class TeamMemberController < ApplicationController
  before_action :check_team_member_rights

  def index
    @members = current_team.manageable_members(current_user).page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def delete
    @member = TeamMember.find(params[:id])
    @member.destroy

    redirect_to manage_team_members_path(current_team.slug)
  end
end
