class AddIndexToPepSeq < ActiveRecord::Migration
  def change
  	add_index :psms, :pep_seq
  end
end
