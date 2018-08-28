# frozen_string_literal: true

class TeamInviteController < ApplicationController
  def new
    @team_invite_submissions = TeamInviteForm.new
  end

  def create
    @team_invite_submissions = TeamInviteForm.new(team_invite_params)
    @team = current_team

    puts('VALID', @team_invite_submissions.valid?)

    if @team_invite_submissions.valid?
      TeamInviteAdder.create_from_email_list(@team_invite_submissions.emails, @team)
      flash[:success] = 'Team invites have been sent!'
      redirect_to manage_invites_path(team: @team.slug)
    else
      flash[:error] = 'Invalid email(s)!'
      redirect_to manage_invites_path(team: @team.slug)
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
