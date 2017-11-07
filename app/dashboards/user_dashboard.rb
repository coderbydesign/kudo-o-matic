require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
      id: Field::Number,
      name: Field::String,
      email: Field::String,
      avatar_url: Field::String,
      slack_name: Field::String,
      admin: Field::Boolean,
      transaction_received_mail: Field::Boolean,
      goal_reached_mail: Field::Boolean,
      summary_mail: Field::Boolean,
      api_token: Field::String,
      deactivated_at: Field::DateTime,
      created_at: Field::DateTime,
      updated_at: Field::DateTime,
      sent_transactions: Field::HasMany.with_options(class_name: 'Transaction'),
      received_transactions: Field::HasMany.with_options(class_name: 'Transaction'),
      votes: Field::HasMany
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
      :id,
      :name,
      :email,
      :slack_name,
      :admin,
      :sent_transactions,
      :received_transactions,
      :deactivated_at
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
      :id,
      :name,
      :email,
      :avatar_url,
      :slack_name,
      :admin,
      :transaction_received_mail,
      :goal_reached_mail,
      :summary_mail,
      :api_token,
      :created_at,
      :updated_at,
      :deactivated_at,
      :sent_transactions,
      :received_transactions,
      :votes
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
      :name,
      :email,
      :slack_name,
      :avatar_url,
      :admin,
      :transaction_received_mail,
      :goal_reached_mail,
      :summary_mail,
      :api_token
  ]

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  def display_resource(user)
    user.name
  end
end
