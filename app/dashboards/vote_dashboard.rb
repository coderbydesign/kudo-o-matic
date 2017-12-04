require "administrate/base_dashboard"

class VoteDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
      id: Field::Number,
      votable_type: Field::String,
      votable_id: Field::Number,
      voter_type: Field::String,
      voter_id: Field::Number,
      vote_flag: Field::Boolean,
      vote_scope: Field::String,
      vote_weight: Field::Number,
      created_at: Field::DateTime,
      updated_at: Field::DateTime,
      transaction_votable: Field::BelongsTo.with_options(class_name: 'Transaction'),
      user_voter: Field::BelongsTo.with_options(class_name: 'User')
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
      :id,
      :transaction_votable,
      :user_voter
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
      :votable_id,
      :votable_type,
      :transaction_votable,
      :voter_id,
      :voter_type,
      :user_voter,
      :created_at,
      :updated_at
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
      :transaction_votable,
      :user_voter
  ]

  # Overwrite this method to customize how votes are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(vote)
  #   "Vote ##{vote.id}"
  # end
end
