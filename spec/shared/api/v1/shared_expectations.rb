def expect_unauthorized_response
  it 'returns an unauthorized message' do
    expected = {
        errors: {
            title: 'Unauthorized',
            detail: 'No valid API-token was provided.',
            code: '401',
            status: '401'
        }
    }.with_indifferent_access

    expect(json).to match(expected)
  end
end

def expect_user_record_not_found_response
  it 'returns a user not found message' do
    expected = {
        errors: [
            {
                title: 'User record not found',
                detail: 'The user record identified by -1 could not be found.',
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
