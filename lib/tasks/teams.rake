namespace :teams do
  desc 'Connect all users, balances and transactions to a new team.'
  task setup: :environment do
    team = Team.create(name: 'Kabisa')
    User.all.each do |user|
      if user.admin?
        team.add_member(user, true)
      elsif team.add_member(user)
      end
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
end