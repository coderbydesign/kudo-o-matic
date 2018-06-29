json.key_format! :dasherize

json.data do
  json.title 'Successfully declined the invite'
  json.detail "The team_invite record identified by id #{@invite.id} was declined successfully."
end
