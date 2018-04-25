object @user => :data
attributes :id, :name, :email, :created_by, :updated_by, :slack_id, :slack_name, :slack_username, :avatar_url

child @transactions, :object_root => false do
    attributes :id, :created_at, :updated_at, :amount, :likes_amount
    node(:activity) { |t| t.activity.name }
    node(:image_url_original) { |t| t.image.url == '/images/original/missing.png' ? nil : t.image.url }
    node(:image_url_thumb) { |t| t.image.url == '/images/original/missing.png' ? nil : t.image.url }
    node(:image_file_name) { |t| t.image_file_name }
    node(:image_content_type) { |t| t.image_content_type }
    node(:image_file_size) { |t| t.image_file_size }
    node(:image_updated_at) { |t| t.image_updated_at }
end

child @votes, :object_root => false do
    attributes :votable_type, :votable_id, :voter_type, :voter_id, :vote_flag, :vote_scope, :vote_weight,
               :created_at, :updated_at
end
