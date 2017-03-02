require "rails_helper"
require "rss"

describe "/feed", type: :request do
  context "no transactions" do
    it "produces an empty feed" do
      expect(parse_feed).to be_empty
    end
  end

  context "given many transactions" do
    before do
      # create 26 transactions, each 1 minute apart, newest first
      @transactions = 26.times.map{|i| create(:transaction, updated_at: Date.yesterday.to_time + i.minute)}.sort_by(&:updated_at).reverse
    end

    it "includes last 25 entries" do
      entries = parse_feed
      expect(extract_ids(entries)).to eq(@transactions.first(25).map(&:id))
    end

    it "includes basic info in entries" do
      entry = parse_feed[0]
      transaction = @transactions.first

      expect(entry.title.content).to include("New transaction")
      expect(entry.summary.content).to eq("#{transaction.sender.name} awarded #{transaction.receiver_name} #{transaction.amount} ₭ for #{transaction.activity_name}")
    end
  end

  def extract_ids(entries)
    entries.map {|e| e.id.content.split("Transaction/")[1].to_i }
  end

  def parse_feed
    get "/feed"
    RSS::Parser.parse(response.body).entries
  end
end
