# frozen_string_literal: true

class TeamAdder
  def self.create(params, current_user)
    name = params[:team][:name]
    slug = params[:team][:slug]
    general_info = params[:team][:general_info]
    logo = params[:team][:logo]

    team = Team.new(
      name: name,
      slug: slug,
      general_info: general_info,
      logo: logo
    )

    save team, current_user
  end

  private

  def self.save(team, current_user)
    if team.save
      team.add_member(current_user, true)
      TransactionAdder.create_for_new_team(team, current_user)
    end

    team
  end
end
