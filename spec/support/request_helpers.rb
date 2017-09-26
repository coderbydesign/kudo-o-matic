module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body).with_indifferent_access
    end

    def expect_unauthorized
      expect(json).to match({error: 'Unauthorized'})
    end
  end
end
