namespace :user do
  desc 'Rake task to create a user with the name of the organization'
  task company: :environment do
    company_name = ENV['COMPANY_USER']

    if company_name.present?
      User.create(name: company_name)
      puts "User with name '#{company_name}' was created successfully"
    else
      puts 'No organization name provided. Please set the COMPANY_USER environment variable in the .env file'
    end
  end
end
