class RemoveGenenameFromPsm < ActiveRecord::Migration
  def change
	  remove_column :psms, :genename
  end
end
