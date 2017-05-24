require 'rails_helper'

describe Activity, type: :model do
  let!(:activity) { Activity.create name:'Helping with Rspec' }

  describe '#to_s' do
    it 'converts activity name to a string' do
      activity.to_s

      expect(activity.name).to be_a(String)
    end
  end
end