class Api::V2::TransactionResource < Api::V2::BaseResource
  attributes :amount, :activity, :votes_count, :api_user_voted, :image_url_original, :image_url_thumb, :image_file_name, :image_content_type, :image_file_size, :image_updated_at
  filters :amount, :activity, :votes_count, :api_user_voted, :image_url_original, :image_url_thumb, :image_file_name, :image_content_type, :image_file_size, :image_updated_at
  has_one :sender
  has_one :receiver
  has_one :balance
  paginator :offset

  def activity
    @model.activity.name
  end

  def api_user_voted
    context[:api_user].voted_for? @model
  end

  def votes_count
    @model.likes_amount
  end

  def image_url_original
    # return nil if the transaction has no original image
    @model.image.url == '/images/original/missing.png' ? nil : @model.image.url
  end

  def image_url_thumb
    # return nil if the transaction has no thumb image
    @model.image.url(:thumb) == '/images/thumb/missing.png' ? nil : @model.image.url(:thumb)
  end
end
