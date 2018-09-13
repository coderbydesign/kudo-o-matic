# == Schema Information
#
# Table name: guidelines
#
#  id         :integer          not null, primary key
#  name       :string
#  kudos      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  teams_id   :integer
#

class Guideline < ApplicationRecord
end
