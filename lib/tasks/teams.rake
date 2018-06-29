namespace :teams do
  desc 'Connect all users, balances and transactions to a new team.'
  task setup: :environment do
    slug = ENV['COMPANY_USER'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

    Team.skip_callback(:create, :after, :setup_team)
    team = Team.find_or_create_by(name: ENV['COMPANY_USER'])
    Team.set_callback(:create, :after, :setup_team)

    User.all.each do |user|
      team.add_member(user, user.admin?)
    end
    Transaction.all.each do |transaction|
      transaction.update_attribute(:team_id, team.id)
    end
    Balance.all.each do |balance|
      balance.update_attribute(:team_id, team.id)
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