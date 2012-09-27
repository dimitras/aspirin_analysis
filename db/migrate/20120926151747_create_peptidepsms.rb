class CreatePeptidepsms < ActiveRecord::Migration
  def change
    create_table :peptidepsms do |t|
      t.integer :peptide_id
      t.integer :psm_id

      t.timestamps
    end
  end
end
