require 'rails_helper'

describe Balance do
  it 'calculates the days left until the end of the year' do
    year = Time.current.year
    day = Date.parse("#{year}-12-28")
    expire = Date.parse("#{year}-12-31")
    left = (expire - day).to_i
    expect(left).to eq(2)
  end

end