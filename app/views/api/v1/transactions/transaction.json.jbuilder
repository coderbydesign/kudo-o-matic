json.key_format! :dasherize

json.data do
  json.id @transaction.id
  json.type 'transactions'

  json.links do
    json.self "#{root_url}api/v1/transactions/#{@transaction.id}"
  end

  json.attributes do
    json.created_at @transaction.created_at
    json.updated_at @transaction.updated_at
    json.amount @transaction.amount
    json.activity @transaction.activity.name
    json.votes_count @transaction.likes_amount
    json.api_user_voted @api_user_voted
    json.image_url_original @transaction.image.url == '/images/original/missing.png' ? nil : @transaction.image.url
    json.image_url_thumb @transaction.image.url == '/images/original/missing.png' ? nil : @transaction.image.url
    json.image_file_name @transaction.image_file_name
    json.image_content_type @transaction.image_content_type
    json.image_file_size @transaction.image_file_size
    json.image_updated_at @transaction.image_updated_at
  end
end
