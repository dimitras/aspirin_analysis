class AddIndexToPepSeqInPeptide < ActiveRecord::Migration
  def change
  	add_index :peptides, :pep_seq
  end
end
