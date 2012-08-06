class AddCols < ActiveRecord::Migration
  def up
	  add_column :psms, :mod_string, :string
	  add_column :psms, :title, :string
	  add_column :psms, :charge, :string
	  add_column :psms, :rtinseconds, :string
	  add_column :psms, :ions1, :text
	  add_column :psms, :mzs, :text
	  add_column :psms, :intensities, :text
  end

  def down
	  remove_column :psms, :mod_string
	  remove_column :psms, :title
	  remove_column :psms, :charge
	  remove_column :psms, :rtinseconds
	  remove_column :psms, :ions1
	  remove_column :psms, :mzs
	  remove_column :psms, :intensities
  end
end
