class RemoveCols < ActiveRecord::Migration
  def up
	  remove_column :peptides, :more
  end

  def down
	  add_column :peptides, :more, :string
  end
end
