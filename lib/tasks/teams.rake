namespace :teams do
  desc 'Connect all users, balances and transactions to a new team.'
  task setup: :environment do
    slug = ENV['COMPANY_USER'].downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '')
    team = Team.create(name: ENV['COMPANY_USER'], slug: slug)
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

  task clear: :environment do
    TeamMember.destroy_all
    Team.destroy_all
  end
end