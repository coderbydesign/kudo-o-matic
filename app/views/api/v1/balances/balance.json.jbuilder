json.key_format! :dasherize

json.data do
  json.id @balance.id
  json.type 'balances'
  json.attributes do
    json.name @balance.name
    json.current @balance.current
    json.created_at @balance.created_at
    json.updated_at @balance.updated_at
  end
end
