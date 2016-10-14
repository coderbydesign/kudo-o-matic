require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do

  describe 'number_to_kudos' do
    {
      2 => "2 ₭",
      42 => "42 ₭",
      876 => "876 ₭",
      5_000 => "5.000 ₭",
      2_000_000 => "2.000.000 ₭",
    }.each do |val, exp|
      it "renders #{val} as '#{exp}'" do
        expect(helper.number_to_kudos(val)).to eq(exp)
      end
    end
  end

end
