class AddPepToPsm < ActiveRecord::Migration
  def change
  	add_column :psms, :peptide_id, :integer
  	add_index :psms, :peptide_id
  end
end
