json.errors do
  json.title 'Invalid JWT Token'
  json.detail 'No valid JSON Web Token was provided.'
  json.code '401'
  json.status '401'
end
