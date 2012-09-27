class CreatePeptidePsmJoinTable < ActiveRecord::Migration
  def change
    create_table :peptides_psms, :id => false do |t|
      t.integer :peptide_id
      t.integer :psm_id
    end
  end
end
