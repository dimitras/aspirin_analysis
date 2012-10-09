class UpdateIndexesInConservations < ActiveRecord::Migration
  def change
  	remove_index :conservations, :primary_species_accno
  	remove_column :conservations, :primary_species_accno
  	add_index :conservations, :mrna_id
  end
end
