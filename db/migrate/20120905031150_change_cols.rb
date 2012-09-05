class ChangeCols < ActiveRecord::Migration
  def up
	  change_column :psms, :mzs, :binary
	  change_column :psms, :intensities, :binary
  end

  def down
	  change_column :psms, :mzs, :text
	  change_column :psms, :intensities, :text
  end
end
