class Conservation < ActiveRecord::Base
  attr_accessible :mrna_id, :primary_species_accno, :seq, :species
end
