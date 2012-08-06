class UpdateCols < ActiveRecord::Migration
  def up
	  remove_column :psms, :ions1
	  rename_column :psms, :mod_string, :mod_positions
	  rename_column :psms, :pep, :pep_seq
  end

  def down
	  add_column :psms, :ions1, :text
	  rename_column :psms, :mod_positions, :mod_string
	  rename_column :psms, :pep_seq, :pep
  end
end
