json.key_format! :dasherize

json.data do
  json.id @goal.id
  json.type 'goals'
  json.attributes do
    json.name @goal.name
    json.amount @goal.amount
    json.achieved_on @goal.achieved_on
    json.created_at @goal.created_at
    json.updated_at @goal.updated_at
  end
end
