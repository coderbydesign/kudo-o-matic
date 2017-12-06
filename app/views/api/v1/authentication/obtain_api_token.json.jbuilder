json.key_format! :dasherize

json.data do
  json.title 'Successfully generated API token'
  json.detail 'JSON Web Token token was validated successfully and a unique API token was generated successfully.'
  json.api_token @user.api_token
  json.user_id @user.id
end
