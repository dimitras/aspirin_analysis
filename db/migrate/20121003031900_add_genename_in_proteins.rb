class AddGenenameInProteins < ActiveRecord::Migration
  def change
	   add_column :proteins, :genename, :string
  end
end
