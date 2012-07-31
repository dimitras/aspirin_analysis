class Peptide < ActiveRecord::Base
  attr_accessible :more, :penalized_rp, :pep_seq, :rank_product

  def psms()
	  #connect to db and create psm object
	  return Psm.find_by_pep(pep_seq)
  end
  
end
