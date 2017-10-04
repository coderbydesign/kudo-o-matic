def expect_unauthorized_response_and_status_code
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

  it 'returns a 401 (unauthorized) status code' do
    expect(response).to have_http_status(401)
  end
end
