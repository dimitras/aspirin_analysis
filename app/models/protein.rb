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

class Protein < ActiveRecord::Base
  attr_accessible :accno, :desc, :seq, :species, :genename

  has_many :psms, :foreign_key => "accno", :primary_key => "accno"
	
end



