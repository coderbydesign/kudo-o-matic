# frozen_string_literal: true

class TeamInviteController < ApplicationController
  before_action :check_team_member_rights, only: [:index, :create, :delete]

  def index
    @team_invite_submissions = TeamInviteForm.new
    @show_team_invite = TeamInvite.where(team_id: current_team).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @team_invite_submissions = TeamInviteForm.new(team_invite_params)
    @team = current_team

    if @team_invite_submissions.valid?
      TeamInviteAdder.create_from_email_list(@team_invite_submissions.emails, @team)
      flash[:success] = 'Team invites have been sent!'
    else
      flash[:error] = 'Invalid email(s)!'
    end
    redirect_to manage_invites_path(team: @team.slug)
  end

  def delete
    invite = TeamInvite.find(params[:id])
    if invite.destroy
      flash[:success] = 'Succesfully deleted invitation!'
    else
      flash[:error] = 'Something went wrong, please try again'
    end
    redirect_to manage_invites_path(team: current_team.slug)
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
