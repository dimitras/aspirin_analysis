class Peptide < ActiveRecord::Base
  # pagination default
  self.per_page = 100
  # accessible attributes for mass assignment
  attr_accessible :penalized_rp, :pep_seq, :rank_product

  # default ordering for the model
  default_scope order("penalized_rp ASC")

  def psms()
	  #connect to db and create psm object
	  return Psm.find_all_by_pep(pep_seq)
  end

end
