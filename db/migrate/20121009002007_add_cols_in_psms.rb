class AddColsInPsms < ActiveRecord::Migration
  def change
	  add_column :psms, :mrna_id, :string
	  add_column :psms, :mod_positions_in_protein, :string
	  add_column :psms, :conserved_mod_positions_in_protein, :string
  end
end
