Balance.delete_all
Goal.delete_all
Transaction.delete_all
Activity.delete_all
User.delete_all

@balance = Balance.find_or_create_by(name: '2017', current: true)

Goal.create(name: "Beers",    amount: 250,  balance: @balance, achieved_on: nil)
Goal.create(name: "Tennis",   amount: 1000, balance: @balance, achieved_on: nil)
Goal.create(name: "Karten",   amount: 1500, balance: @balance, achieved_on: nil)
Goal.create(name: "Barbeque", amount: 2500, balance: @balance, achieved_on: nil)