class CreatePsmProteinJoinTable < ActiveRecord::Migration
  def change
    create_table :psms_proteins, :id => false do |t|
      t.integer :psm_id
      t.integer :protein_id
    end
  end
end
