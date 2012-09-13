require 'psm'

class Peptide < ActiveRecord::Base
  # pagination default
  self.per_page = 50
  # accessible attributes for mass assignment
  attr_accessible :penalized_rp, :pep_seq, :rank_product

  # default ordering for the model
  default_scope order("penalized_rp ASC")

  # The following method does not allow you to take 
  # advantage of Rails associations. Use the following instead:
  #
  has_many :psms, :dependent => :destroy, :inverse_of => :peptide
  has_and_belongs_to_many :proteins

  # @peptide = @psm.peptide
  # 
  # you will need to work out how to join the tables on load via the IDs

  def psms()
	  #connect to db and create psm object
	  return Psm.find_all_by_pep_seq(pep_seq)
	  # return Psm.find_all_by_pep_seq(pep_seq).where(:cutoff => 0..cutoff)
  end

end
