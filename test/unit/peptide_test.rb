# == Schema Information
#
# Table name: peptides
#
#  id           :integer          not null, primary key
#  pep_seq      :string(255)
#  rank_product :float
#  penalized_rp :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  cutoff       :float
#  experiment   :string(255)
#

require 'test_helper'

class PeptideTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
