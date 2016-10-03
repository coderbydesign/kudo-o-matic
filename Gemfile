source 'https://rubygems.org'

ruby '2.3.1'

# Rails
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

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


gem 'draper', '= 3.0.0.pre1'
gem "administrate", github: "pablo-co/administrate", branch: "rails5"
gem 'simple_form'
gem 'bootstrap3_autocomplete_input'
gem "font-awesome-rails"
gem 'haml-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'mocha'
  gem "minitest-rails"
  gem "minitest-rails-capybara"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'spring'

  gem 'guard'
  gem 'guard-minitest'
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'rails-controller-testing'
end
