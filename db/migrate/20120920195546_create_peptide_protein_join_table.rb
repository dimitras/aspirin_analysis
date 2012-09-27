class CreatePeptideProteinJoinTable < ActiveRecord::Migration
  def change
    create_table :peptides_proteins, :id => false do |t|
      t.integer :peptide_id
      t.integer :protein_id
    end
  end
end
