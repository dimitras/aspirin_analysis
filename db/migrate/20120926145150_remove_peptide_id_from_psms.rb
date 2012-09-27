class RemovePeptideIdFromPsms < ActiveRecord::Migration
  def up
	  remove_index :psms, :peptide_id
	  remove_column :psms, :peptide_id
  end
  def down
	  add_column :psms, :peptide_id, :integer
	  add_index :psms, :peptide_id
  end
end
