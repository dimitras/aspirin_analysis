class AddCol < ActiveRecord::Migration
  def up
	  add_column :psms, :assigned_yions, :text
  end

  def down
	  remove_column :psms, :assigned_yions
  end
end
