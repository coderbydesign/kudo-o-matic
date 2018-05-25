# frozen_string_literal: true

class Team < ActiveRecord::Base
  after_create :create_balances_and_goals
  has_attached_file :logo, styles: {thumb: '600x600'}
  validates_attachment :logo, content_type: {content_type: ['image/jpeg']}
  validates_with AttachmentSizeValidator, attributes: :logo, less_than: 10.megabytes
  process_in_background :logo

  has_many :memberships, class_name: 'TeamMember', foreign_key: :team_id
  has_many :users, through: :memberships
  has_many :balances

  def add_member(user, admin = false)
    TeamMember.create(user: user, team: self, admin: admin)
  end

  def remove_member(user)
    TeamMember.find_by_user_id_and_team_id(user.id, id).delete
  end

  def member?(user)
    TeamMember.find_by_user_id_and_team_id(user.id, id).present?
  end

  private

  def create_balances_and_goals
    balance = Balance.create(name: "My first balance", current: true,
                             team_id: id)
    Goal.create(name: 'First goal', amount: 500, balance_id: balance.id)
    Goal.create(name: 'Second goal', amount: 1000, balance_id: balance.id)
    Goal.create(name: 'Third goal', amount: 1500, balance_id: balance.id)
    user = User.new(name: name, company_user: true)
    user.save(validate: false)
    add_member(user)
  end
end
