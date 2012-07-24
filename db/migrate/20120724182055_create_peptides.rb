class CreatePeptides < ActiveRecord::Migration
  def change
    create_table :peptides do |t|
      t.string :pep_seq
      t.float :rank_product
      t.float :penalized_rp
      t.string :more

      t.timestamps
    end
  end
end
