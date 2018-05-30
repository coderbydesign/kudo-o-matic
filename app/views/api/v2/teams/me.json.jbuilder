json.key_format! :dasherize

json.data do
  json.amountOfTeams @teams.size
  json.teams @teams do |team|
    json.id team.id
    json.name team.name
    json.slug team.slug
    json.logo team.logo.exists? ? team.logo.url : ''
  end
end