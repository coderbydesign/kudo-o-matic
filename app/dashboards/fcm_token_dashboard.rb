require 'administrate/base_dashboard'

class FcmTokenDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
      id: Field::Number,
      token: Field::String,
      created_at: Field::DateTime,
      updated_at: Field::DateTime,
      user: Field::BelongsTo,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
      :id,
      :token,
      :created_at,
      :updated_at,
      :user
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
      :id,
      :token,
      :created_at,
      :updated_at,
      :user
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
      :token,
      :user
  ]

    # Overwrite this method to customize how fcm tokens are displayed
    # across all pages of the admin dashboard.
    #
    # def display_resource(fcm_token)
    #   "FcmToken ##{fcm_token.id}"
    # end
end
