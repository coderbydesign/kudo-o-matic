atom_feed do |feed|
  feed.title("Kudos-o-Matic last 25 transactions")
  feed.updated(@transactions.max_by(&:created_at).try(:created_at))
  feed.author do |author|
    author.name "Kudos-o-Matic"
  end

  @transactions.each do |transaction|
    feed.entry(transaction, url: root_url, updated: transaction.created_at) do |entry|
      entry.title("New transaction on #{request.host}")
      entry.summary("#{transaction.sender.name} awarded #{transaction.receiver_name_feed} #{number_to_kudos(transaction.amount)} for #{transaction.activity_name_feed}")
    end
  end
end
