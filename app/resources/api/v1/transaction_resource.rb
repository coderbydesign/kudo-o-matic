class Api::V1::TransactionResource < Api::V1::BaseResource
  attributes :amount, :image_file_name, :image_content_type, :image_file_size, :image_updated_at
  filters :amount, :image_file_name, :image_content_type, :image_file_size, :image_updated_at
  has_one :sender
  has_one :receiver
  has_one :activity
  has_one :balance
  has_many :votes
end
