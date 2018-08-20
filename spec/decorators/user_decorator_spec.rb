# frozen_string_literal: true

require 'rails_helper'

describe UserDecorator do
  let(:user) do
    create(:user).decorate
  end
  let(:user2) do
    create(:user, restricted: true).decorate
  end

  context 'Regular user' do
    it 'it shows the name' do
      expect(user.name).to eq('John')
    end
  end

  context 'Restricted user' do
    it 'it hides the name' do
      expect(user2.name).to eq('Hidden')
    end
  end
end
