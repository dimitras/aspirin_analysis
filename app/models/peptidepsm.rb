# == Schema Information
#
# Table name: peptidepsms
#
#  id         :integer          not null, primary key
#  peptide_id :integer
#  psm_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Peptidepsm < ActiveRecord::Base
  attr_accessible :peptide_id, :psm_id

  belongs_to :peptide
  belongs_to :psm
end
