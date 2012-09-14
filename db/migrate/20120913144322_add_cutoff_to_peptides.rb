class AddCutoffToPeptides < ActiveRecord::Migration
  def up
    add_column :peptides, :cutoff, :float
  end
  def down
    remove_column :peptides, :cutoff
  end
end
