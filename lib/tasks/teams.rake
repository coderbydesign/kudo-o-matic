namespace :teams do
  desc 'Connect all users, balances and transactions to a new team.'
  task setup: :environment do
    slug = ENV['COMPANY_USER'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

    Team.skip_callback(:create, :after, :setup_team)
    team = Team.find_by_name_and_slug(ENV['COMPANY_USER'], slug)
    Team.set_callback(:create, :after, :setup_team)

    User.all.each do |user|
      team.add_member(user, user.admin?)
    end
    Transaction.all.each do |transaction|
      transaction.team_id = team.id
      transaction.save
    end
    Balance.all.each do |balance|
      balance.team_id = team.id
      balance.save
    end
  end

  desc 'Remove all current teams, team members and company users'
  task clear: %i[destructive environment] do
    TeamMember.destroy_all
    Team.destroy_all
    User.where(company_user: true).destroy_all
    puts 'Deleted all teams, team members and company users'
  end
end