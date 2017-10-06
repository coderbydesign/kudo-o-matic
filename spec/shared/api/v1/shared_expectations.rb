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

def expect_status_401_unauthorized
  it 'returns a 401 (unauthorized) status code' do
    expect(response).to have_http_status(401)
  end
end
