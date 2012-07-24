class Peptide < ActiveRecord::Base
  attr_accessible :more, :penalized_rp, :pep_seq, :rank_product
end
