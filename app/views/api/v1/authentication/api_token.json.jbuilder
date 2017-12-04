json.key_format! :dasherize

json.data do
  json.api_token @user.api_token
  json.user_id @user.id
end
