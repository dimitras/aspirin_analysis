class Protein < ActiveRecord::Base
  attr_accessible :accno, :desc, :seq

  has_and_belongs_to_many :peptides

end
