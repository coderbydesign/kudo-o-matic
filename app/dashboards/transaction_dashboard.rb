require "administrate/base_dashboard"

class TransactionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
      id: Field::Number,
      amount: Field::Number.with_options(suffix: ' ₭'),
      created_at: Field::DateTime,
      updated_at: Field::DateTime,
      sender: Field::BelongsTo.with_options(class_name: 'User'),
      receiver: Field::BelongsTo.with_options(class_name: 'User'),
      activity: Field::BelongsTo,
      balance: Field::BelongsTo
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
      :id,
      :amount,
      :sender,
      :receiver,
      :activity,
      :balance,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
      :id,
      :amount,
      :sender,
      :receiver,
      :activity,
      :balance,
      :created_at,
      :updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form #{transaction.sender}(`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
      :amount,
      :sender,
      :receiver,
      :activity,
      :balance
  ]

  # Overwrite this method to customize how transactions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(transaction)
  #   "Transaction ##{transaction.id}"
  # end
end
