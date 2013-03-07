class AddTopPeaksAssignedToPeptides < ActiveRecord::Migration
  def change
  	add_column :peptides, :top_peaks_assigned, :integer
  	add_index :peptides, :top_peaks_assigned
  end
end
