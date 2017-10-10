json.key_format! :dasherize

json.data do
  json.id @balance.id.nil? ? nil : @balance.id.to_s # return nil when the balance id is nil, instead of an empty string

  json.type 'balances'
  json.attributes do
    json.created_at @balance.created_at
    json.updated_at @balance.updated_at
    json.name @balance.name
    json.amount @balance.amount
    json.current @balance.current
  end
end
