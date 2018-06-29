namespace :devise do
  desc 'Send password reset instructions to all users without a password.'
  task send_password_reset_instructions: :environment do
    User.where(encrypted_password: [nil, '']).each do |user|
      user.send_reset_password_instructions

      # Also confirm the user, because they already confirmed their
      # e-mail by using Google.
      user.confirm
    end
  end
end