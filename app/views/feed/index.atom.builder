atom_feed do |feed|
  feed.title("#{root_url}: last 25 transactions")
  feed.updated(@transactions.first.try(:updated_at))
  feed.author do |author|
    author.name "Kudo-o-matic"
  end

  @transactions.each do |transaction|
    feed.entry(transaction, url: root_url) do |entry|
      entry.title("New transaction on #{root_url}")
      entry.summary("#{transaction.sender.name} awarded #{transaction.receiver_name} #{number_to_kudos(transaction.amount)} for #{transaction.activity_name}")
    end
  end
end
