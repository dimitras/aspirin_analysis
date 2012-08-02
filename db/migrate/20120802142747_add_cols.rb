class AddCols < ActiveRecord::Migration
  def up
	  add_column :psms, :plot, :string
	  add_column :psms, :ionstable, :text
  end

  def down
	  remove_column :psms, :plot
	  remove_column :psms, :ionstable
  end
end
