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
      @transactions = create_list(:transaction, 26)
    end

    it "includes last 25 entries" do
      entries = parse_feed

      expect(entries.size).to eq(25)
      expect(entries.none?{|e| e.id.content.split("Transaction/")[1].to_i == @transactions.last.id}).to be true
    end

    it "includes basic info in entries" do
      entry = parse_feed[0]
      transaction = @transactions.first

      expect(entry.title.content).to include("New transaction")
      expect(entry.summary.content).to eq("#{transaction.sender.name} awarded #{transaction.receiver_name} #{transaction.amount} ₭ for #{transaction.activity_name}")
    end
  end

  def parse_feed
    get "/feed"
    RSS::Parser.parse(response.body).entries
  end
end
