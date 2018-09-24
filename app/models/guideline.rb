# == Schema Information
#
# Table name: guidelines
#
#  id         :integer          not null, primary key
#  name       :string
#  kudos      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#

class Guideline < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 4, maximum: 100 }
  validates :kudos, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000, message: "is not correct. You can't give negative ₭udos or exceed over 1000"}

  belongs_to :team

  def self.guidelines_between(from, to, team_id)
    gl = []
    Guideline.where(team_id: team_id).each do |g|
      gl.push g if g.kudos >= from && g.kudos <= to
    end
    gl
  end
end
