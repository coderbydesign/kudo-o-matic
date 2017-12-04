# expect record counts

def expect_balance_count_same
  it 'does not change the balance record count' do
    expect(record_count_before_request).to be == Balance.count
  end
end

def expect_balance_count_decrease
  it 'decreases the balance record count' do
    expect(record_count_before_request).to be > Balance.count
  end
end

def expect_user_count_same
  it 'does not change the user record count' do
    expect(record_count_before_request).to be == User.count
  end
end
