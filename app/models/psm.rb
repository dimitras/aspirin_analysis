class Psm < ActiveRecord::Base
  attr_accessible :accno, :cutoff, :genename, :mod, :pep, :pep_score, :query, :rep
end
