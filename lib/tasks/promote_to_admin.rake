namespace :admin do
  desc "Rake task to promote a user to admin"
  task promote: :environment do
    @user = User.first

    if @user.try(:admin)
      puts "User #{@user.name} is already admin"
    else
      @user.update(admin: true)
      puts "#{@user.name} is now admin"
    end
  end
end