OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
  provider: 'google_oauth2',
  uid: '123545',
  info: {
    name: 'John User',
    email: "john@#{ENV.fetch('DEVISE_DOMAIN', 'gmail.com')}",
    image: 'http://lorempixel.com/512/512/people'
  }
})
