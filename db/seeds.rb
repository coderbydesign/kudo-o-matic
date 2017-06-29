Balance.delete_all
Goal.delete_all
Transaction.delete_all
Activity.delete_all
User.delete_all

@balance = Balance.find_or_create_by(name: 'New Balance', current: true)

Goal.create(name: "Goal 1", amount: 1500,  balance: @balance, achieved_on: nil)
Goal.create(name: "Goal 2", amount: 5000, balance: @balance, achieved_on: nil)
Goal.create(name: "Goal 3", amount: 10000, balance: @balance, achieved_on: nil)

