# expect JSON respones

def expect_unauthorized_response
  it 'returns an unauthorized message' do
    expected = {
        errors: [
            {
                title: 'Unauthorized',
                detail: 'No valid API-token was provided.',
                code: '401',
                status: '401'
            }
        ]
    }.with_indifferent_access

    expect(json).to match(expected)
  end
end

def expect_previous_goal_record_not_found_response
  it 'returns a previous goal not found message' do
    expected = {
        errors: [
            {
                title: 'Previous goal record not found',
                detail: 'There is no previous goal record.',
                code: '404',
                status: '404'
            }
        ]
    }.with_indifferent_access

    expect(json).to match(expected)
  end
end

def expect_transaction_record_not_found_response
  it 'returns a transaction not found message' do
    expected = {
        errors: [
            {
                title: 'Transaction record not found',
                detail: 'The transaction record identified by -1 could not be found.',
                code: '404',
                status: '404'
            }
        ]
    }.with_indifferent_access

    expect(json).to match(expected)
  end
end

# expect record counts

def expect_balance_count_same
  it 'does not change the balance record count' do
    expect(record_count_before_request).to be == Balance.count
  end
end

def expect_goal_count_same
  it 'does not change the goal record count' do
    expect(record_count_before_request).to be == Goal.count
  end
end

def expect_goal_count_increase
  it 'increases the goal record count' do
    expect(record_count_before_request).to be < Goal.count
  end
end

def expect_transaction_count_same
  it 'does not change the transaction record count' do
    expect(record_count_before_request).to be == Transaction.count
  end
end

def expect_transaction_count_increase
  it 'increases the transaction record count' do
    expect(record_count_before_request).to be < Transaction.count
  end
end

def expect_user_count_same
  it 'does not change the user record count' do
    expect(record_count_before_request).to be == User.count
  end
end

def expect_vote_count_same
  it 'does not change the vote record count' do
    expect(record_count_before_request).to be == Vote.count
  end
end

def expect_vote_count_increase
  it 'increases the vote record count' do
    expect(record_count_before_request).to be < Vote.count
  end
end

def expect_vote_count_decrease
  it 'decreases the vote record count' do
    expect(record_count_before_request).to be > Vote.count
  end
end

# expect HTTP status codes

def expect_status_200_ok
  it 'returns a 200 (ok) status code' do
    expect(response).to have_http_status(200)
  end
end

def expect_status_201_created
  it 'returns a 201 (created) status code' do
    expect(response).to have_http_status(201)
  end
end

def expect_status_204_no_content
  it 'returns a 204 (no content) status code' do
    expect(response).to have_http_status(204)
  end
end

def expect_status_302_found
  it 'returns a 302 (found) status code' do
    expect(response).to have_http_status(302)
  end
end

def expect_status_401_unauthorized
  it 'returns a 401 (unauthorized) status code' do
    expect(response).to have_http_status(401)
  end
end

def expect_status_404_not_found
  it 'returns a 404 (not found) status code' do
    expect(response).to have_http_status(404)
  end
end
