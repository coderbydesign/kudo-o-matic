json.data do
  json.id @user.id
  json.name @user.name
  json.email @user.email
  json.created_at @user.created_at
  json.updated_at @user.updated_at
  json.slack_id @user.slack_id
  json.slack_name @user.slack_name
  json.slack_username @user.slack_username
  json.avatar_url @user.avatar_url

  json.transactions @transactions do |t|
    json.id t.id
    json.created_at t.created_at
    json.updated_at t.updated_at
    json.amount t.amount
    json.activity t.activity.name
    json.votes_count t.likes_amount
    json.image_url_original t.image.url == '/images/original/missing.png' ? nil : t.image.url
    json.image_url_thumb t.image.url == '/images/original/missing.png' ? nil : t.image.url
    json.image_file_name t.image_file_name
    json.image_content_type t.image_content_type
    json.image_file_size t.image_file_size
    json.image_updated_at t.image_updated_at
  end

  json.votes @votes do |v|
    json.votable_type v.votable_type
    json.votable_id v.votable_id
    json.voter_type v.voter_type
    json.voter_id v.voter_id
    json.vote_flag v.vote_flag
    json.vote_scope v.vote_scope
    json.vote_weight v.vote_weight
    json.created_at v.created_at
    json.updated_at v.updated_at
  end
end