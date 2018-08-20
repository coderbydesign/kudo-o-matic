json.key_format! :dasherize

json.data do
  json.title 'Successfully accepted the invite'
  json.detail "The team_invite record identified by id #{@invite.id} was accepted successfully."
end
