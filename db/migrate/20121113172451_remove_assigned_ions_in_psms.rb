class RemoveAssignedIonsInPsms < ActiveRecord::Migration
	 def change
	  remove_column :psms, :assigned_yions
  end
end
