json.key_format! :dasherize

json.data do
  json.amountOfTeams @teams.size
  json.teams @teams do |team|
    json.id team.id
    json.name team.name
    json.slug team.slug
    json.logo team.logo.exists? ? team.logo.url : ''
  end
  json.amountOfInvites @invites.size
  json.invites @invites do |invite|
    json.id invite.id
    json.name invite.team.name
    json.logo invite.team.logo.exists? ? invite.team.logo.url : ''
  end
end