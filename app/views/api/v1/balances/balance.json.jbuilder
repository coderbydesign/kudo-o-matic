json.key_format! :dasherize

json.data do
  json.id @balance.id
  json.type 'balances'
  json.attributes do
    json.current @balance.current
    json.name @balance.name
  end
end
