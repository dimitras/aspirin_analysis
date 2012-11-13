# == Schema Information
#
# Table name: psms
#
#  id                                 :integer          not null, primary key
#  pep_seq                            :string(255)
#  query                              :string(255)
#  accno                              :string(255)
#  pep_score                          :float
#  rep                                :string(255)
#  mod                                :string(255)
#  cutoff                             :float
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  mod_positions                      :string(255)
#  title                              :string(255)
#  charge                             :string(255)
#  rtinseconds                        :string(255)
#  mzs                                :binary
#  intensities                        :binary
#  mrna_id                            :string(255)
#  mod_positions_in_protein           :string(255)
#  conserved_mod_positions_in_protein :string(255)
#  enzyme                             :text
#  assigned_yions_mzs_table           :binary
#  assigned_yions_intensities_table   :binary
#  assigned_bions_mzs_table           :binary
#  assigned_bions_intensities_table   :binary
#  yions                              :binary
#  bions                              :binary
#

require 'test_helper'

class PsmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
