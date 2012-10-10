# == Schema Information
#
# Table name: conservations
#
#  id         :integer          not null, primary key
#  mrna_id    :string(255)
#  species    :string(255)
#  seq        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Conservation < ActiveRecord::Base
  attr_accessible :mrna_id, :seq, :species
  belongs_to :psm, :primary_key => "mrna_id", :foreign_key => "mrna_id"
end
