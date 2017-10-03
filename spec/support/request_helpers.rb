require 'rails_helper'

module RequestHelpers
  def json
    JSON.parse(response.body).with_indifferent_access
  end

  def assigned_id
    json['data']['id']
  end

  def assigned_created_at
    json['data']['attributes']['created-at']
  end

  def assigned_updated_at
    json['data']['attributes']['updated-at']
  end

  def assigned_image_updated_at
    json['data']['attributes']['image_updated_at']
  end

  def to_api_timestamp_format(timestamp)
    timestamp.strftime('%FT%T.%LZ')
  end
end
