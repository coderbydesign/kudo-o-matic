# frozen_string_literal: true

class TeamAdder
  def self.create(params, current_user)
    name = params[:name]

    team = Team.new(
      name: name
    )

    save team, current_user
  rescue
    team
  end

  private

  def self.save(team, current_user)
    if team.save!
      team.add_member(current_user, true)
      TransactionAdder.create_for_new_team(team, current_user)
    end

    team
  end
end
