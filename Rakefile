# frozen_string_literal: true
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

task :destructive do
  puts 'This task is destructive! Are you sure you want to continue? [y/N]'
  input = STDIN.gets.chomp
  raise RuntimeError unless input.downcase == 'y'
end

Rails.application.load_tasks
