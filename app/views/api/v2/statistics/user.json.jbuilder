json.data do
  json.sent @sent_transactions_user
  json.received @received_transactions_user
  json.total @total_transactions_user
end
