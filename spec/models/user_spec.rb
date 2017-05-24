require 'rails_helper'

describe User, type: :model do
  let!(:user) { User.create name: 'John', avatar_url:'/kabisa_lizard.png' }
  let!(:user_2) { User.create name: 'Jane' }

  describe '#to_s' do
    it 'converts activity name to a string' do
      user.to_s

      expect(user.name).to be_a(String)
    end
  end

  describe '#picture_url' do
    it 'finds the picture url of the user' do
      user.picture_url
      expect(user.picture_url).to eq('/kabisa_lizard.png')
    end

    it 'finds no picture url of the user' do
      user_2.picture_url
      expect(user_2.picture_url).to eq('/no-picture-icon.jpg')
    end
  end

  describe '#from_omniauth' do

  end
end