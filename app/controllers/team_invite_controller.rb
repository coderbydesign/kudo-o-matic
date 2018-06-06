# frozen_string_literal: true

class TeamInviteController < ApplicationController
  def create
    @invites = TeamInviteSubmission.new(team_invite_params)

    if @invites.valid?
      TeamInviteAdder.create_from_email_list(@invites.emails, current_team)
      flash[:success] = 'Team invites have been sent!'
      redirect_to manage_path(team: current_team.slug)
    else
      render 'teams/manage'
    end
  end

  private

  def team_invite_params
    params.required(:team_invite_submission).permit(:emails)
  end
end
