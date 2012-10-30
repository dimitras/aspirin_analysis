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

class Peptide < ActiveRecord::Base
  # pagination default
  self.per_page = 50

  # accessible attributes for mass assignment
  attr_accessible :penalized_rp, :pep_seq, :rank_product, :cutoff, :experiment

  # default ordering for the model
  default_scope order("penalized_rp ASC")

  # define assosiations
  has_many :peptidepsms
  has_many :psms, :through => :peptidepsms, :order => 'psms.pep_score DESC'

  scope :filtered, lambda { |experiment, cutoff|
    where("peptides.experiment = ? AND peptides.cutoff = ?", experiment, cutoff)
  }
  
  scope :longer_than, lambda { |length|
    {
      :conditions => ["LENGTH(peptides.pep_seq) <= ?", length]
    }
  }

  scope :enzymed, lambda { |enzyme|
    {
      :include => :psms,
      :conditions => ["psms.enzyme = ?", enzyme]
    }
  }

end
