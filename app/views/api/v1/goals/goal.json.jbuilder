json.key_format! :dasherize

json.data do
  json.id @goal.id
  json.type 'goals'
  json.attributes do
    json.achieved_on @goal.achieved_on
    json.name @goal.name
    json.amount @goal.amount
  end
end
