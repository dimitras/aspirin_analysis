class ChangeAssignedYionsType < ActiveRecord::Migration
  def up
	  change_column :psms, :assigned_yions, :binary
  end

  def down
	  change_column :psms, :assigned_yions, :text
  end
end
