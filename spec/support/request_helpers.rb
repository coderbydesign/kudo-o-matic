require 'rails_helper'

module RequestHelpers
  def json
    JSON.parse(response.body).with_indifferent_access
  end
end
