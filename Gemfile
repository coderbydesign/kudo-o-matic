source 'https://rubygems.org'

ruby '2.3.1'

# Rails
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'dotenv-rails', group: [:development, :test]

gem 'jquery-ui-rails', '~> 6.0', '>= 6.0.1'

gem 'slack-notifier', '~> 2.1.0'

gem 'settingslogic', '~> 2.0', '>= 2.0.9'

gem 'bourbon', '~> 4.3', '>= 4.3.4'

gem 'rubocop', '~> 0.47.1', require: false

gem 'scss_lint', require: false

gem 'md_emoji', git: 'https://github.com/egonm12/md_emoji.git', branch: 'master'

gem 'redcarpet', '~> 3.3', '>= 3.3.4'

gem 'timecop', '~> 0.8.1'

# Database
gem 'pg', '~> 0.18'

# Web server
gem 'puma', '~> 3.0'

# Assets
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'acts_as_votable', '~> 0.10.0'
gem 'railties', '~> 5.0', '>= 5.0.0.1'
gem 'chronic', '~> 0.10.2'

gem 'draper', '= 3.0.0.pre1'
gem "administrate", github: "pablo-co/administrate", branch: "rails5"
gem 'simple_form'
gem "font-awesome-rails"
gem 'haml-rails'

gem 'devise'
gem "omniauth-google-oauth2"
gem 'pry'

gem "autoprefixer-rails"


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'rspec-rails', '~> 3.5'
  gem 'poltergeist'
  gem 'capybara'

  gem 'factory_girl_rails'
  gem 'launchy'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
  gem 'spring'
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'database_cleaner'
end
