def expect_unauthorized_message_and_status_code
  it 'returns an unauthorized message' do
    expect(json).to match({error: 'Unauthorized'})
  end

  it 'returns a 401 (unauthorized) status code' do
    expect(response).to have_http_status(401)
  end
end
