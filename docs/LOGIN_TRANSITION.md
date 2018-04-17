# Transition to new login system
The Google login button has been removed in favor of a good ol' login form. 
Users who have signed up via Google currently don't have a password. When the transition is made, 
those without a password can't login.

The following steps should be taken to make the transition as smooth as possible.

## Step 1: Notify users
All users should be notified about the new changes and that they will soon receive an e-mail with a 
password reset link.

## Step 2: Send password reset e-mail 
When all users are notified, `rake devise:send_password_reset_instructions` can be run inside the project folder.
This simple rake task will send password reset instructions to all users with an empty `encrypted_password` field.

Because we also introduced email confirmation, this rake task will automatically confirm those users, because we know their
email addresses exist.

## Step 3: Check login on mobile app
Users probably won't have to re-authenticate because their API token is unaffected. If this is not the case, they should
sign-in via the new form inside the mobile app.
