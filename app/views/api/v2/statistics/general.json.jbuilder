json.data do
  json.transactions do
    json.week @transactions_week
    json.month @transactions_month
    json.total @transactions_total
  end

  json.kudos do
    json.week @kudos_week
    json.month @kudos_month
    json.total @kudos_total
  end
end