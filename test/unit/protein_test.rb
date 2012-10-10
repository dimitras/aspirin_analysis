# == Schema Information
#
# Table name: proteins
#
#  id         :integer          not null, primary key
#  accno      :string(255)
#  desc       :string(255)
#  species    :string(255)
#  seq        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  genename   :string(255)
#

require 'test_helper'

class ProteinTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
