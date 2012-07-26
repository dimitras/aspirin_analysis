class CreatePsms < ActiveRecord::Migration
  def change
    create_table :psms do |t|
      t.string :pep
      t.string :query
      t.string :accno
      t.float :pep_score
      t.string :rep
      t.string :mod
      t.string :genename
      t.float :cutoff

      t.timestamps
    end
  end
end
