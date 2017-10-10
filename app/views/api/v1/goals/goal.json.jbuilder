json.key_format! :dasherize

json.data do
  json.id @goal.id.nil? ? nil : @goal.id.to_s # return nil when the goal id is nil, instead of an empty string
  json.type 'goals'
  json.attributes do
    json.created_at @goal.created_at
    json.updated_at @goal.updated_at
    json.name @goal.name
    json.amount @goal.amount
    json.achieved_on @goal.achieved_on
  end
end
