namespace :devise do
  desc 'Send password reset instructions to all users without a password.'
  task send_password_reset_instructions: :environment do
    User.where(encrypted_password: [nil, ''])
        .each(&:send_reset_password_instructions)
  end
end