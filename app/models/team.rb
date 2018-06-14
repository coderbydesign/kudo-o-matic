# frozen_string_literal: true

class Team < ActiveRecord::Base
  after_create :setup_team
  has_attached_file :logo, styles: {thumb: '320x120'}
  validates :name, presence: true
  validates :slug, presence: true
  validates_attachment :logo, content_type: {content_type: %w(image/jpeg image/png)}
  validates_with AttachmentSizeValidator, attributes: :logo, less_than: 10.megabytes
  process_in_background :logo

  has_many :memberships, class_name: 'TeamMember', foreign_key: :team_id
  has_many :users, through: :memberships
  has_many :balances
  has_many :goals, through: :balances
  has_many :transactions
  has_many :likes, class_name: 'Vote'

  def add_member(user, admin = false)
    TeamMember.create(user: user, team: self, admin: admin)
  end

  def remove_member(user)
    TeamMember.find_by_user_id_and_team_id(user.id, id).delete
  end

  def member?(user)
    TeamMember.find_by_user_id_and_team_id(user.id, id).present?
  end

  def current_goals
    goals.where(balance: Balance.current(id))
  end

  private

  def setup_team
    # Create balances and goals
    balance = Balance.create(name: "My first balance", current: true,
                             team_id: id)
    Goal.create(name: 'First goal', amount: 500, balance_id: balance.id)
    Goal.create(name: 'Second goal', amount: 1000, balance_id: balance.id)
    Goal.create(name: 'Third goal', amount: 1500, balance_id: balance.id)

    # Create company user
    user = User.new(name: name, company_user: true)
    user.save(validate: false)
    add_member(user)
  end
end
