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
  attr_accessible :accno, :desc, :seq

  has_and_belongs_to_many :peptides
  has_and_belongs_to_many :psms
  has_many :conservations

end
