balance = Balance.create(name: Date.today.year, current: true)

(1..3).each {|i| Goal.create(name: "Goal #{i}", amount: i * 500, balance: balance)}
