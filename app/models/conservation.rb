class Conservation < ActiveRecord::Base
  attr_accessible :mrna_id, :seq, :species
  belongs_to :psm, :primary_key => "mrna_id", :foreign_key => "mrna_id"
end
