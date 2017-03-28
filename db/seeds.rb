Balance.delete_all
Goal.delete_all
Transaction.delete_all
Activity.delete_all
User.delete_all

@balance = Balance.find_or_create_by(name: '2016', amount: 1342, current: true)
# @balance = Balance.find_or_create_by(name: '2016', amount: 0, current: true)

Goal.create(name: "Beers",    amount: 250,  balance: @balance, achieved_on: nil)
Goal.create(name: "Tennis",   amount: 1000, balance: @balance, achieved_on: nil)
Goal.create(name: "Karten",   amount: 1500, balance: @balance, achieved_on: nil)
Goal.create(name: "Barbeque", amount: 2500, balance: @balance, achieved_on: nil)

TransactionAdder.create(
  sender: "Harry",
  receiver: "William",
  activity: "being an awesome brother",
  amount: 500
)

TransactionAdder.create(
  sender: "William",
  receiver: "Tommy",
  activity: "keeping the door open for me",
  amount: 5
)

TransactionAdder.create(
  sender: "William",
  receiver: "Harry",
  activity: "being an awesome brother",
  amount: 250
)