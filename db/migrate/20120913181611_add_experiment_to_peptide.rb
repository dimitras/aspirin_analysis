class AddExperimentToPeptide < ActiveRecord::Migration
 def up
    add_column :peptides, :experiment, :string
  end
  def down
    remove_column :peptides, :experiment
  end
end
