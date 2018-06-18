# frozen_string_literal: true

class TeamInviteController < ApplicationController
  def create
    @team_invite_submissions = TeamInviteForm.new(team_invite_params)
    @team = current_team

    if @team_invite_submissions.valid?
      TeamInviteAdder.create_from_email_list(@team_invite_submissions.emails, current_team)
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
    flash[:error] = 'Already accepted or declined invitation'
    redirect_to root_path
  end

  def decline
    invite = TeamInvite.find(params['id'])
    unless invite.complete?
      invite.decline
      flash[:success] = "Successfully declined invite for #{invite.team.name}"
      return redirect_to root_path
    end
    flash[:error] = 'Already accepted or declined invitation'
    redirect_to root_path
  end

  private

  def team_invite_params
    params.required(:team_invite_form).permit(:emails)
  end
end
