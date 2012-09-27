# == Schema Information
#
# Table name: spectras
#
#  id         :integer          not null, primary key
#  query      :string(255)
#  title      :string(255)
#  ions1      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class SpectraTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
