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

  def accept
    invite = TeamInvite.find(params['id'])
    unless invite.complete?
      invite.accept
      flash[:success] = "Successfully accepted invite for #{invite.team.name}"
      return redirect_to root_path
    end
    flash[:error] = "Already accepted or declined invitation"
    redirect_to root_path
  end

  def decline
    invite = TeamInvite.find(params['id'])
    unless invite.complete?
      invite.decline
      flash[:success] = "Successfully declined invite for #{invite.team.name}"
      return redirect_to root_path
    end
    flash[:error] = "Already accepted or declined invitation"
    redirect_to root_path
  end

  private

  def team_invite_params
    params.required(:team_invite_submission).permit(:emails)
  end
end
