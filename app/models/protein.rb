# == Schema Information
#
# Table name: proteins
#
#  id         :integer          not null, primary key
#  accno      :string(255)
#  desc       :string(255)
#  seq        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Protein < ActiveRecord::Base
  attr_accessible :accno, :desc, :seq, :species

  has_many :psms, :foreign_key => "accno", :primary_key => "accno"
	
end



